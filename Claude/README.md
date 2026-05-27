# Codechella Madrid — Claude Workspace

Scratch / working project folder for Claude-driven analysis inside the
[Codechella-Madrid 2026](..) workshop repo.

## Directory Structure

```
Claude/
├── CLAUDE.md              # Research rules & estimation philosophy (permanent)
├── README.md              # This file — project-specific notes
├── code/
│   ├── R/                 # R scripts
│   ├── python/            # Python scripts
│   └── stata/             # Stata do-files
├── data/
│   ├── raw/               # Original source data (never modify these)
│   └── clean/             # Cleaned and merged datasets
├── output/
│   ├── tables/            # Generated tables (LaTeX, CSV)
│   └── figures/           # Generated figures (PDF, PNG)
├── documents/             # Outside papers and PDFs (split with /split-pdf)
├── decks/                 # Beamer presentations (rhetoric of decks philosophy)
├── notes/                 # Scratch notes, ideas, miscellaneous
└── progress_logs/         # Session logs for continuity across Claude conversations
```

## Folder Purposes

- **`code/`** — All scripts, organized by language. R, Python, Stata each get their own subfolder.
- **`data/raw/`** — Original source data. Treat as read-only; never modify in place.
- **`data/clean/`** — Cleaned, merged, analysis-ready datasets produced by `code/`.
- **`output/`** — Generated artifacts. `tables/` for LaTeX/CSV, `figures/` for PDF/PNG.
- **`documents/`** — Outside PDFs, papers, references. Use `/split-pdf` for deep reads.
- **`decks/`** — Beamer presentations. Follow the Rhetoric of Decks philosophy.
- **`notes/`** — Scratch space, ideas, miscellaneous.
- **`progress_logs/`** — Session-by-session logs so Claude can pick up where it left off across conversations.

## On `CLAUDE.md` and `README.md`

- **`CLAUDE.md`** is copied from a permanent template (`~/mixtapetools/claude/CLAUDE.md`) and edited per project. It encodes research rules, estimation philosophy, key decisions, and instructions for Claude. It is the durable memory of this project.
- **`README.md`** is this file — project-specific human-facing documentation. Update freely as the project evolves.
- **`progress_logs/`** maintains continuity across Claude sessions. Each session writes a dated log of what was done and what's next.

## Relationship to the Parent Repo

This folder sits inside [`Codechella-Madrid/`](..), the public workshop repo for Codechella Madrid 2026 (May 25–28, CUNEF Auditorium). The parent repo's `CLAUDE.md` is the authoritative operating manual for the workshop slides and labs. **This `Claude/` folder is a workspace** — do not put workshop-facing slide or lab edits here; those belong in `../Slides/` and `../Labs/`, with the upstream sync to `~/the-remix-tour/glasgow/`.

## Overview

[2–3 sentences on what this workspace is being used for.]

## Collaborators

[List collaborators and roles, if any.]

## Status

**Phase:** Setup — workspace just initialized 2026-05-26.

## Key Files

- (none yet)
