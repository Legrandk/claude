---
paths:
  - "**/*"
---
# DevKit

All supported services are Dockerized. Use `devkit` to run commands inside the service container.

This rule defines the execution boundary for service commands.

## Usage

```bash
devkit exec <service_name> <cmd>
```

The service name is the **name of the current directory** unless the user specifies it explicitly.

Examples:

```bash
# Example: ~/Projects/communication-center/
devkit exec communication-center rails test
devkit exec communication-center rails console
devkit exec communication-center jt-linter
```

## Service Detection

Determine `<service_name>` from the current project directory name unless the user specifies it explicitly.

Examples:

- `~/Projects/communication-center` -> `communication-center`
- `~/Projects/farming` -> `farming`

If the service name is ambiguous, state the assumption before running commands.

## Hard Boundary

Use `devkit` for all service commands.

Do not bypass `devkit` with raw Docker commands.

Forbidden raw Docker commands include, but are not limited to:

- `docker run`
- `docker exec`
- `docker inspect`
- `docker compose`
- `docker build`
- `docker stop`
- `docker start`
- `docker rm`
- `docker volume`
- `docker network`

The only allowed raw Docker command is:

```bash
docker cp <container>:<source_path> <destination_path>
```

`docker cp` is allowed only to copy generated files from the container back to the host when explicitly needed.

Do not use raw Docker commands to:

- run service commands
- inspect containers
- inspect mounts
- modify containers
- rebuild containers
- work around failing `devkit` commands
- install dependencies
- run `bundle install`
- run tests
- run consoles
- run linters

## If DevKit Fails or Gets Stuck

If a `devkit` command fails, times out, crashes, or cannot complete the task:

1. Stop.
2. Do not improvise with raw Docker commands.
3. Do not inspect containers directly.
4. Do not run alternative Docker commands.
5. Explain the problem clearly.
6. Ask the user for help using `AskUserQuestionTool`.

The explanation must include:

- what command failed
- what the agent was trying to achieve
- what error or blocker was observed
- what options seem plausible
- what decision is needed from the user

Example:

```txt
I am stuck rebuilding the service image.

The Gemfile changed, so dependencies must be installed into the image.
`devkit build <service_name>` failed at a pre-existing build step.
I must not bypass devkit with raw Docker commands.

How should I proceed?

1. Retry with a clean devkit rebuild if available.
2. Use the team's known rebuild procedure.
3. Ask the team/check CI.
4. Stop and document the blocker.
```

## Gemfile / Gemfile.lock

When `Gemfile` changes, dependencies may be baked into the service image.

Use the devkit rebuild flow.

Preferred flow:

```bash
devkit stop <service_name>
devkit rm <service_name>
devkit build <service_name>
devkit up -d <service_name>
```

If `devkit rm` is not available, fails, or behaves unexpectedly, stop and ask the user using `AskUserQuestionTool`.

Do not replace it with `docker rm`.

After rebuilding, always copy the Gemfile.lock back to the host. This is mandatory, not optional:

```bash
docker cp <service_name>:/usr/local/jtservice/Gemfile.lock ./Gemfile.lock
```

Do this immediately after `devkit build` completes — before any other step.

Do not run:

```bash
docker run --rm ...
docker exec ...
docker inspect ...
docker compose ...
```

Do not run `bundle install` through raw Docker.

Do not inspect Docker mounts to work around devkit.

## Rebuilding the Container

Rebuild when any root-level files that are baked into the image change.

Common examples:

- `Gemfile`
- `KafkaConsumersList`
- `Messagebusfile`
- `Procfile.consumers`

Use devkit only:

```bash
devkit stop <service_name>
devkit rm <service_name>
devkit build <service_name>
devkit up -d <service_name>
```

Then copy generated files back to the host only if needed:

```bash
docker cp <service_name>:/usr/local/jtservice/Gemfile.lock ./Gemfile.lock
```

## Standalone Libraries (e.g. Ruby gems)

Some projects are standalone libraries with their own `docker-compose.yml` and are **not** registered as devkit services. These projects cannot use `devkit exec` because `devkit` always `cd`s into `~/Projects/devkit` and only knows about services defined there.

For standalone libraries, use `docker compose` directly from the project root.

To build and run tests, credentials for GitHub Packages are required as Docker build args. Obtain them from devkit secrets:

```bash
eval "$(devkit secrets list | grep GH_PACKAGES)"
```

Then build and run:

```bash
GH_PACKAGES_READ_USER=$GH_PACKAGES_READ_USER \
  GH_PACKAGES_READ_TOKEN=$GH_PACKAGES_READ_TOKEN \
  docker compose build
docker compose run --rm app
```

## Rules

- ALWAYS use `devkit exec <service_name> <cmd>` to run service commands.
- The service name is derived from `basename "$PWD"` unless specified by the user.
- NEVER run service commands directly on the host.
- NEVER use raw Docker commands except `docker cp` for copying generated files back to the host, and `docker compose` for standalone libraries (see above).
- NEVER use raw Docker as a workaround when devkit fails.
- If devkit cannot complete the task, stop and ask the user with `AskUserQuestionTool`.
- Exception: Kotlin/Java services do **NOT** use devkit.
- Exception: Standalone libraries with their own `docker-compose.yml` use `docker compose` directly with credentials from `devkit secrets list`.
