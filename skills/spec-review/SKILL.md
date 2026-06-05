---
name: spec-review
description: Lightweight spec review. Reads relevant docs, identifies ambiguity and gaps, asks clarifying questions one at a time, and edits documentation only after decisions are confirmed.
origin: user
---

# Spec Review

1. Read all spec/operations/security docs in the target directory
2. Identify ambiguities, inconsistencies, and gaps
3. Ask clarifying questions ONE AT A TIME via AskUserQuestion
4. Only after all decisions confirmed, apply edits across affected files
5. Keep all responses under 900 tokens, use bullets
6. Do NOT modify any code files - documentation only
