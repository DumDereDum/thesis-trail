# ThesisTrail

**ENG** | [RUS](README.ru.md)

AI instructions and templates to help students plan, review, and defend coursework and theses, and help supervisors review the work and prepare questions.

## Why ThesisTrail

Students use AI while working on coursework and theses, but may struggle to formulate a problem, explain their decisions, or substantiate their results. ThesisTrail aims to support the process from defining the task to defending the finished work, with an emphasis on the student's understanding and personal contribution.

Students and supervisors can use different AI tools and exchange files through Git or manually.

## Project status

ThesisTrail is in early development. The first planned version is **v0.1.0**.

The workflows and file structure below describe the agreed development direction. They are not a list of implemented features. This repository currently contains the project documentation and the MIT License; installers, skills, and templates will be added later.

## Planned workflows

1. **Define the task.** Starting from an empty folder or an existing project, the student works with AI to clarify the goal, scope, personal contribution, and verification criteria. The result is saved in `brief.md`.
2. **Review a version of the work.** The supervisor opens a specific version and receives a draft `review.md` with comments pointing to passages in the text or locations in the code, plus questions for the student. The supervisor checks the comments before sharing them.
3. **Address feedback and rehearse the defense.** The student works through the comments and answers questions one at a time. AI gives feedback after the student has answered independently.

## Installation and files

Installation is not available yet. A single-command setup is planned through `install.sh` for macOS/Linux and `install.ps1` for Windows.

In a student's project, the planned structure is:

- `.tt/` — shared files, templates, scripts, and installed version information.
- AI client skill folders — skills for the selected client.
- `docs/thesis-trail/` — completed learning documents, including `brief.md` and `review.md`.

Copyable instructions are also planned for use in a regular web chat.

## License

[MIT](LICENSE).
