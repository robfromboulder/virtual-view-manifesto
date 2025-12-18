# Claude Code Instructions for "The Virtual View Manifesto"

**Project**: The Virtual View Manifesto
**Author**: Rob Dickinson (robfromboulder)
**Current Version**: 0.52
**Last Updated**: 2025-12-16
**Document Length**: ~1963 lines / ~9,000 words

---

## 🎯 Project Overview

This is a technical manifesto about virtual view hierarchies in SQL databases, with Trino as the reference implementation. The document is published as part of Rob's GitHub portfolio and is intended to establish a repeatable architectural pattern for the data engineering community.

**Primary File**: `README.md` (the complete manifesto)
**Output Format**: Markdown with Mermaid diagrams for GitHub rendering
**Related Tools**: ViewMapper and ViewZoo (Apache 2 licensed projects by Rob)

---

## 📐 Document Structure Quick Reference

The README is organized in these major sections:
1. **Introduction** (lines 45-150): Problem statement, classical vs virtual views
2. **Principles** (lines 152-599): Core architectural principles with examples
3. **Use Cases** (lines 601-1250): Eight practical scenarios (note: Use Case 8 is stub for future completion)
4. **Implementation Guide** (lines 1252-1575): Setup, complete e-commerce example, documentation/tooling
5. **Common Pitfalls** (lines 1577-1747): Seven mistakes and solutions
6. **When NOT to Use** (lines 1749-1879): Three anti-patterns
7. **Related Tools** (lines 1881-1915): ViewMapper and ViewZoo documentation
8. **Glossary** (lines 1917-1940): Technical term definitions
9. **Footer** (lines 1942-1963): License, thanks, metadata

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
- **Test rendering in GitHub preview** - Always validate before committing
- Use flowcharts for architecture and dependencies (`flowchart TD` by default)
- Use Gantt charts for timeline progressions
- **Use black-and-white only** - No custom colors or fills for readability in both light and dark modes
- **Use quotes for labels even when not strictly required** - use `Tables[("Physical Tables")]`, not `Tables[(Physical Tables)]`

### Example Naming Conventions

**CRITICAL**: All SQL examples must follow the three-level naming convention consistently throughout the document.

**Physical tables** (connector.schema.table):
- ✅ `postgresql.myapp.users`
- ✅ `postgresql.myapp.orders`
- ✅ `iceberg.myapp.events`
- ❌ `postgresql.users` (missing schema)
- ❌ `postgresql.app.users` (should be `myapp` to match catalog)

**Virtual views** (catalog.schema.view):
- ✅ `myapp.users.all`
- ✅ `myapp.orders.pending`
- ✅ `myapp.events.base`
- ❌ `myapp.users` (missing view name, only two levels)
- ❌ `myapp.all_users` (use feature schema: `users.all`)

**Schema → Catalog transformation pattern**:
The examples should reinforce that the physical schema name becomes the catalog name:
- **Before (physical)**: `postgresql.myapp.users` - `myapp` is a schema in PostgreSQL
- **After (virtual)**: `myapp.users.all` - `myapp` is promoted to a catalog, `users` is a feature schema

**Feature-based organization**:
- Second level (schema) should represent features or domains
- Common patterns: `myapp.users.*`, `myapp.orders.*`, `myapp.events.*`, `myapp.products.*`
- Avoid generic names like `myapp.data.*` in examples unless specifically showing generic setup

**View naming patterns**:
- `.all` - Common entry point (e.g., `myapp.users.all`)
- `.base` - Base layer in hierarchy
- `.merged` - Merge layer combining sources
- `.filtered` - Privacy/filtering layer
- `.enriched` - Transformation layer

**Internal schemas**:
- Use `myapp.internal.*` for multi-layer hierarchies when demonstrating layer separation
- Keep simple examples within feature schemas (e.g., `myapp.users.base` rather than `myapp.internal.users_base`)

**Consistency across document sections**:
- All Principles examples must follow these conventions
- All Use Cases examples must follow these conventions
- All Implementation Guide examples must follow these conventions
- All Pitfall examples must follow these conventions
- Mermaid diagrams must use fully qualified names (three levels)

**Why this matters**:
- Teaches the transformation pattern: schema → catalog
- Makes the abstraction crystal clear
- Shows readers exactly how to structure their own implementations
- Every example reinforces the same mental model
- Readers learn by repetition and consistency

---

## 🔍 Content Guidelines

### Scope and Emphasis
1. **Scope**: Concepts apply to any database, but Trino is reference implementation due to federation capabilities
2. **Audience assumptions**: Brief primer on classical views included for contrast
3. **Dogmatism level**: Strongly opinionated but pragmatic
4. **Example complexity**: Both simple and realistic for each major point
5. **Iceberg emphasis**: Primary motivating use case, integrated throughout but not separate section

### Use Case Selection Criteria
When considering new use cases or examples:
- **Focus on the virtual view pattern**, not just Trino capabilities
- Ask: "Does this demonstrate something you *couldn't easily do* without virtual views?"
- **Avoid use cases that are just Trino features** (e.g., "Cross-Database Federation" showcases Trino's federation but doesn't highlight the swappability/versioning that makes virtual views unique)
- Good use cases demonstrate: swappable implementations, independent layer evolution, static-to-live progressions, runtime reconfiguration
- Each use case should show a problem that virtual views solve better than alternatives

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

**The README is ~9,700 words** (significantly streamlined from original ~70K). When working with it:

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

**Improving information flow**:
- Place context/setup paragraphs BEFORE examples (not after)
- Position diagrams early to visualize concepts immediately
- Remove redundant subsections when content is already covered elsewhere
- Ensure diagram elements match surrounding text (e.g., if diagram shows demo/test data, mention it)
- Make example headers consistent ("Example of..." pattern)
- Use GitHub callout boxes (> [!CAUTION], > [!TIP]) for important warnings and tips

---

## 📝 Current Status

**Version**: 0.52 (Draft)
**Status**: Work in progress, streamlined for initial peer review
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

**Last Updated**: 2025-12-16
**Maintained By**: Claude Code (for Rob's review and approval)

---

## 🔄 Change Log

### 2025-12-16 (version 0.52)
- **Merged Implementation Guide and Appendix** to eliminate duplication and improve flow
- Eliminated redundant Steps 3, 5, 6 (generic examples superseded by e-commerce example)
- Removed standalone "Appendix: Complete Example" section
- Updated Table of Contents to remove Appendix link
- Document reduced from 1998 to 1963 lines, ~9,000 words
- Net change: 35 lines reduced

### 2025-12-16 (version 0.51)
- **Refined all eight use case challenge/solution statements** for clarity, specificity, and value proposition
- **Added "Use Case Selection Criteria" section** to CLAUDE.md emphasizing virtual view patterns over Trino-specific features
- No structural changes; document remains at 1998 lines, ~9,200 words

### 2025-12-16 (version 0.5)
- **Major restructuring**: Eliminated "Practical Patterns" and "View Lifecycle Management" sections
- Merged Pattern 2 (Prototyping Progression) into Use Case 1 with Gantt timeline diagram
- Created Use Case 4 from Pattern 3 (Per-Feature Hierarchies / Isolating Per-Feature Storage)
- Created Use Case 5 from Pattern 4 (Runtime Configuration Switching)
- Removed Pattern 1 (Three-Layer Stack) as redundant with other content
- Moved bottom-up replacement guidance from View Lifecycle to Use Case 3
- Moved view deletion guidance to new Pitfall 5 (Attempting to Delete Base Views)
- Reordered use cases for pedagogical flow: prototyping → testing → schema evolution → feature isolation → runtime config → privacy → Iceberg → cost routing
- Renamed Use Case 6 from "Enforcing Privacy and Compliance Controls" to "Ensuring Privacy and Compliance"
- Added link tables (numbered lists with anchors) to Common Pitfalls and When NOT to Use sections for easier navigation
- Use Case 8 (Cost and Availability Routing) left as stub for future completion
- Document reduced from 2189 to 1998 lines, ~9,200 words
- Net change: 191 lines reduced

### 2025-12-16 (version 0.4)
- Reordered Common Pitfalls by decreasing impact and frequency (Type Mismatch → Forgetting Dependents → Breaking Assumptions → Permissions → Lost Definitions → Circular Dependencies)
- Consolidated Anti-Patterns 1 & 4 ("Over-Abstraction" and "Single-Layer Hierarchies") into single section
- Reduced anti-pattern count from 4 to 3
- Voice improvements: "A single view is meh" and other conversational tweaks
- Added practical guidance: test migrations in dev/staging, consider sorting in application code
- Net change: 45 lines reduced (119 deletions, 75 insertions)
- Document reduced from 2234 to 2189 lines, ~9,600 words

### 2025-12-16 (version 0.3)
- Major document streamlining: reduced from ~70,000 words to ~9,721 words
- Added CAUTION callout at document start about work-in-progress status
- Renamed Principle 1 from "Not Schemas" to "Not Physical Schemas" for clarity
- Simplified all eight principles by removing redundant explanatory text and some Mermaid diagrams
- Removed Mermaid diagrams from Principle 1 (Bad/Good comparison), Principle 3 (Gantt), and Principle 5 (type mismatch)
- Added GitHub callout boxes for warnings (Principle 4, 6) using > [!CAUTION] and > [!TIP] syntax
- Streamlined decision trees and implementation bullets throughout
- Simplified Principle 7 by removing detailed ViewZoo git workflow (already covered in Related Tools)
- Reduced glossary by removing Entry/Filter/Merge Layer definitions (covered in Pattern 1)
- Updated ViewZoo and ViewMapper references to inline links where appropriate
- Net change: 134 lines reduced (235 deletions, 101 insertions)

### 2025-12-15 (version 0.2)
- Improved information flow in Introduction section
- Added "icing on physical schema" metaphor earlier for better contrast
- Removed redundant "Why Trino?" subsection
- Repositioned classical views diagram for immediate visualization
- Added demo/test data sources to virtual view diagram
- Standardized example headers with "Example of..." pattern
- Updated Mermaid guidelines to require black-and-white for light/dark mode readability
- Added "Improving information flow" editing pattern to Common Editing Patterns

### 2025-12-10 (version 0.1)
- Initial CLAUDE.md created from AUTHORS_NOTES.md
- Added collaboration preferences (complete drafts, priority order)
- Added future topics backlog
- Clarified target audience (Trino users first)
- Added voice guidelines (humor/emojis only when payoff is obvious)