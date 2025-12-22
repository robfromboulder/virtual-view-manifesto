
---

## Related Tools

### ViewMapper

**Purpose**: Agentic schema mapper for Trino views

**Repository**: [github.com/robfromboulder/viewmapper](https://github.com/robfromboulder/viewmapper)

**Use when**: Hierarchies grow beyond 5-6 views or span teams

**Features**:
- Generates Mermaid diagrams from Trino metadata
- Shows cross-catalog dependencies
- Identifies orphaned views (no dependents, no dependencies)
- Exports to Markdown for documentation
- Detects circular dependencies
- Apache 2 licensed

---

### ViewZoo

**Purpose**: Lightweight storage for Trino views

**Repository**: [github.com/robfromboulder/viewzoo](https://github.com/robfromboulder/viewzoo)

**Use when**: Need maximum flexibility, want git integration, avoiding commitment to specific connector

**Features**:
- File-based view storage (JSON on coordinator filesystem)
- No external dependencies (no database or object store required)
- Git integration for version control workflows
- Easy to backup and migrate (just copy directory)
- Apache 2 licensed
