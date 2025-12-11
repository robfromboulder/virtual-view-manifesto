# Claude Code Instructions for "The Virtual View Manifesto"

**Project**: The Virtual View Manifesto
**Author**: Rob Dickinson (robfromboulder)
**Current Version**: 0.1
**Last Updated**: 2025-12-10
**Document Length**: ~2379 lines / ~70,000 words

---

## 🎯 Project Overview

This is a technical manifesto about virtual view hierarchies in SQL databases, with Trino as the reference implementation. The document is published as part of Rob's GitHub portfolio and is intended to establish a repeatable architectural pattern for the data engineering community.

**Primary File**: `README.md` (the complete manifesto)
**Output Format**: Markdown with Mermaid diagrams for GitHub rendering
**Related Tools**: ViewMapper and ViewZoo (Apache 2 licensed projects by Rob)

---

## 📐 Document Structure Quick Reference

The README is organized in these major sections:
1. **Introduction** (lines 1-162): Problem statement, classical vs virtual views
2. **Eight Principles** (lines 164-737): Core architectural principles with examples
3. **Use Cases** (lines 739-1273): Six practical scenarios when to use virtual views
4. **Practical Patterns** (lines 1275-1538): Four common hierarchy designs
5. **Implementation Guide** (lines 1540-1707): Step-by-step getting started
6. **View Lifecycle Management** (lines 1709-1784): Creating, replacing, dropping views
7. **Common Pitfalls** (lines 1786-1928): Six mistakes and solutions
8. **When NOT to Use** (lines 1930-2089): Four anti-patterns
9. **Related Tools** (lines 2091-2127): ViewMapper and ViewZoo documentation
10. **Glossary** (lines 2129-2162): Technical term definitions
11. **Appendix** (lines 2164-2357): Complete end-to-end example
12. **Footer** (lines 2359-2379): License, thanks, metadata

---

## 👥 Target Audience

- **Primary**: Trino users (full-stack engineers, application architects, big-data practitioners)
- **Secondary**: Everyone else interested in SQL view patterns
- **Assumptions**: Familiar with SQL views but may not have thought about them architecturally
- **Needs**: Practical guidance, not academic theory
- **Appreciation**: Technical detail and concrete examples
- **Focus**: Keep content optimized for Trino users first

---

## ✍️ Tone and Voice Requirements

### Voice Characteristics
- **Strongly opinionated but not fundamentalist**
- **Plain language and simple sentence construction**
- Use Rob's natural speaking voice (casual, practical, not overly formal)
- "Manifesto" is tongue-in-cheek to attract attention to typically boring database topic
- **Avoid "I" and "we" language**; use third-person objective
- Think **Douglas Adams meets database architecture**
- **Clean and precise as a manifesto** - humor is welcome but shouldn't distract or add complexity
- **Humor and emojis**: Use sparingly, only when payoff is obvious

### Rob's Natural Speaking Patterns
Examples from transcription:
- "This ends up being really, really useful"
- "That's kind of the theory"
- "Let me give you a very concrete set of examples"
- "This is a yawner, right?"
- "That's pretty cool"
- Occasional emoji in written form (but don't overuse)
- Technical but accessible
- Acknowledges simplifications ("admittedly a simplification")

### Editorial Standards
- Be honest about limitations
- Openly recognize constraints and other potential points of view
- Pragmatic over dogmatic
- When in doubt: simpler is better
- **Never use em dashes (—)**: They cause formatting issues with web content and signal AI-generated text to readers. Use commas instead, extending sentences naturally without colons or dashes as breaks

---

## 📝 Word Choice Guidelines

Preferred terminology (and why):

| Use | Instead of | Reason |
|-----|-----------|--------|
| Virtual views | Logical views | Emphasizes detachment from physical |
| Layer | Level | Implies responsibility, not just hierarchy |
| Swappable | Replaceable | Implies designed for it |
| Application catalog | Feature catalog | Either works, depends on context |
| Federation | Data virtualization | More concrete |

---

## 📋 Success Criteria

The manifesto is successful if readers:

1. ✅ Understand virtual views as architectural pattern, not just database feature
2. ✅ Can implement basic prototyping → production progression
3. ✅ Know when to use (and not use) the pattern
4. ✅ Can plan Iceberg migration using virtual views
5. ✅ Understand the eight principles and why they matter
6. ✅ Have links to ViewMapper and ViewZoo for implementation

---

## 🔗 Related Projects

Always include these links where relevant:

- **ViewMapper**: [github.com/robfromboulder/viewmapper](https://github.com/robfromboulder/viewmapper)
  (Agentic schema mapper for Trino views)

- **ViewZoo**: [github.com/robfromboulder/viewzoo](https://github.com/robfromboulder/viewzoo)
  (Lightweight storage for Trino views)

Both are Apache 2 licensed, created by Rob.

---

## 🔄 Revision Workflow

### When Making Content Changes

1. **Check prose consistency and flow**
2. **Ensure examples are clear and compelling**
3. **Verify Mermaid diagrams render correctly** (use GitHub preview)
4. **Check that all cross-references work** (anchors, links, section references)
5. **Verify tone consistency** (technical but accessible, opinionated but pragmatic)
6. **Update version metadata** at bottom of README:
   - Bump version number (e.g., 0.1 → 0.2 for minor, 1.0 for major)
   - Update "Last Updated" date

### When Making Major Changes

**IMPORTANT**: When making substantial revisions to the manifesto structure, voice, or strategy:

1. **Update this CLAUDE.md file** to reflect new patterns or preferences
2. **Document new section structures** in the "Document Structure Quick Reference"
3. **Add new terminology** to word choice guidelines if needed
4. **Update success criteria** if goals change
5. **Update line numbers** when new content has been reviewed and is ready to commit
6. **Commit CLAUDE.md changes** alongside README changes

This ensures future Claude sessions have the most current context.

---

## 🎨 Formatting Guidelines

### GitHub Rendering
- Standard GitHub-flavored Markdown
- Mermaid diagrams for visualizations
- Code samples throughout (always use proper language tags)
- No need to mention installation/configuration details (covered by linked projects)

### Code Blocks
- Always specify language: ```sql, ```python, ```bash, etc.
- Keep examples realistic but concise
- Include both simple and realistic examples for major points
- Use comments sparingly (code should be self-evident)

### Mermaid Diagrams
- Use flowcharts for architecture and dependencies
- Use Gantt charts for timeline progressions
- Keep styling consistent (use same color scheme)
- Test rendering in GitHub preview

---

## 🔍 Content Guidelines

### Scope and Emphasis
1. **Scope**: Concepts apply to any database, but Trino is reference implementation due to federation capabilities
2. **Audience assumptions**: Brief primer on classical views included for contrast
3. **Dogmatism level**: Strongly opinionated but pragmatic
4. **Example complexity**: Both simple and realistic for each major point
5. **Iceberg emphasis**: Primary motivating use case, integrated throughout but not separate section

### Example Structure Pattern
For each major principle or use case:
1. **Simple example** (3-10 lines of SQL)
2. **Realistic example** (20-50 lines showing production complexity)
3. **Explanation** (why it matters, when to use it)
4. **Visual** (Mermaid diagram when helpful)

---

## 🤖 Working With Claude Code

### Collaboration Preferences

**Rob prefers complete drafts** - changes in one section often affect other sections, and Rob has good diff tools to review complete changes.

**Priority order for all work**:
1. **Accuracy and terminology consistency** (paramount)
2. **Conciseness and logical flow** (next priority)
3. **Creativity** (only when specifically requested)

**Always validate Mermaid diagrams** when making changes to ensure they render correctly.

**Proactive suggestions welcome** for:
- More consistent use of technical terms
- More accurate terminology
- Structural improvements

### Optimizations for Large Document Processing

**The README is very large (~70K words)**. When working with it:

1. **Provide complete drafts**: When making changes, provide the full updated content
2. **Reference by section name**: "Update the Principle 5 section" rather than "update lines 450-531"
3. **Use Edit tool strategically**: For precise changes, but be prepared to show complete context
4. **Validate cross-references**: When editing one section, check if other sections reference it
5. **Check the ToC**: Update Table of Contents if adding/removing/renaming sections

### Common Editing Patterns

**Adding a new example**:
- Identify the section
- Read that section only
- Add example following the simple → realistic pattern
- Verify it fits the voice and tone

**Restructuring a section**:
- Read the full section first
- Make an edit plan
- Update content
- Check cross-references from other sections
- Update ToC if section name changed

**Adding a new principle/use case/pattern**:
- Determine where it fits in the hierarchy
- Follow existing structural patterns
- Add to ToC
- Add cross-references from relevant sections
- Generate Mermaid diagram if applicable

---

## 📝 Current Status

**Version**: 0.1 (Draft)
**Status**: Awaiting peer review and community feedback
**Next Milestone**: 1.0 release after incorporating feedback
**Entire document is open for review**

---

## 📌 Quick Command Reference

When you ask Claude to work on this project, you can use these shortcuts:

- **"Update Principle N"**: Edit specific principle section
- **"Add example to Use Case N"**: Add new example to use case section
- **"Review tone in [section]"**: Check voice consistency
- **"Verify all Mermaid diagrams"**: Test diagram rendering
- **"Check cross-references"**: Validate all internal links
- **"Bump version"**: Update version and date metadata
- **"Update CLAUDE.md"**: Update this file with new patterns/preferences

---

## 🔖 Notes

- This is a living document that should be updated as the manifesto evolves
- Claude should treat this file as the source of truth for how to collaborate on the manifesto
- When in doubt about tone, style, or structure, refer to this guide
- Rob may add notes or preferences here over time—always check for updates

---

**Last Updated**: 2025-12-10
**Maintained By**: Claude Code (for Rob's review and approval)

---

## 🔄 Change Log

### 2025-12-10
- Initial CLAUDE.md created from AUTHORS_NOTES.md
- Added collaboration preferences (complete drafts, priority order)
- Added future topics backlog
- Clarified target audience (Trino users first)
- Added voice guidelines (humor/emojis only when payoff is obvious)