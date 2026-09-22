# Progress Tracking

`progress.json` is structured, git-tracked state for the course: per-lesson
exercise/quiz status and a running list of concept gaps (things you got
wrong somewhere that are worth revisiting). It's not meant to be hand-edited.

Two things write to it:
- **Claude**, during exercise grading — updates the matching lesson/exercise
  entry and appends to `concept_gaps` for anything called out as a weak spot
  (see `CLAUDE.md`'s Grading rules).
- **The IDE**, after you complete a lesson's `quiz.toml` — records the score
  and which questions you missed.

The IDE's Course Progress panel reads this file to show what's done and
what needs another look, and can pull the latest copy or commit+push your
local quiz results (never silently — always an explicit button).

Human-readable grade write-ups still live in `grades/` per `CLAUDE.md` —
this file is the structured/machine-readable counterpart, not a replacement.
