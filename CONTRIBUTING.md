# Contributing to "The Virtual View Manifesto"
This project uses [Claude Code](https://claude.ai/code) for development and test automation. See `CLAUDE.md` for project-specific instructions.

## What This Project Is
This is a **personal manifesto** advocating for a specific architectural pattern. It's opinionated by design. I'm not trying to be neutral or cover every possible database system equally. Trino is the reference implementation because it's where I originally developed and refined these ideas, and because it's awesome. 🐰

## What I'm Looking For

### Accuracy
If I got something wrong about Trino, Iceberg, SQL standards, or database behavior, please tell me. I want this to be technically accurate, not just opinionated.

### Clarity
If something is confusing, unclear, or poorly explained, I want to know. You don't need to have the fix, just pointing out "this section lost me" is valuable.

### Better Examples
If you have a more compelling example that explains a point better than mine, open an issue with details!

### Missing Context
If I made assumptions that aren't obvious, or skipped steps that beginners would need, let me know.

If you disagree with the core premise (that virtual views are useful), that's fine, but this probably isn't the document for you. If you agree with the premise but see something wrong, **please contribute**.

## How to Contribute

### Open a GitHub Issue (Preferred)
This is the easy play. Please open an [GitHub issue](https://github.com/robfromboulder/virtual-view-manifesto/issues) if you:

- **Found a technical error**: "Actually, Trino doesn't work that way..."
- **Have a question**: "Does this pattern work with Athena?"
- **Want to suggest an improvement**: "You should add an example for X..."
- **Just want to complain**: "This entire section is confusing and I don't know why but it is"

All of these are helpful. Seriously. Even the complaints.

### Submit a Pull Request (Ask First?)
Look, I'll be honest. The odds of me accepting a pull request that significantly revises this manifesto are...honestly low. This is a personal portfolio project and I'm trying to establish a coherent voice and perspective, based on years of using these ideas with Trino and Iceberg. If you have a big idea, **[open an issue](https://github.com/robfromboulder/virtual-view-manifesto/issues)** and let's hash it out.

### Code of Conduct
Please be respectful. Critique ideas, not people. GitHub is a public forum, so act accordingly.

### License
By contributing (issues, PRs, comments), you agree that your contributions can be used under the same CC0 1.0 license as the rest of this project. Basically, you're giving your feedback to the public domain, same as the document itself.
