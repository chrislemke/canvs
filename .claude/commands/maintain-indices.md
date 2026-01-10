---
description: Maintain _indices folder - create/update index files for all project folders
allowed-tools: Task, Read, Write, Edit, Bash, Glob, Grep, Skill
---

Maintain the _indices folder for this project. $ARGUMENTS

## Your Task

### Step 1: Check Meta File Freshness
First, check if _meta.yaml files seem outdated (e.g., `updated` date is old or `primary_files` don't match actual files). If they appear stale, run `/maintain-meta` first using the Skill tool.

### Step 2: Identify Folders Needing Indices
Scan the project for folders that need index files:
- **Include**: All top-level folders + major subfolders (like specs/tech, specs/design)
- **Exclude**: Individual planning subfolders (01-77) - the planning_index.yaml will summarize these
- **Major subfolder rule**: A subfolder is "major" if it has its own _meta.yaml and significant content

### Step 3: For Each Folder
Check if `_indices/<folder_name>_index.yaml` exists:

**If MISSING - Create new index:**
1. Read the folder's `_meta.yaml` file for context
2. List all files in the folder
3. Create index file using the template structure from `_templates/index.template.yaml`
4. Include: metadata, files list with summaries, related links

**If EXISTS - Update if needed:**
1. Compare current folder contents with index
2. Add entries for new files
3. Remove entries for deleted files
4. Update the `updated` date if changes were made

### Step 4: Update master.yaml
Add `index:` entries in `_indices/master.yaml` for any newly created index files.

### Step 5: Summary
Provide a concise report:
- Total folders scanned
- Index files created (list them)
- Index files updated (list them)
- Any issues encountered

## Index File Structure
Use this structure (from `_templates/index.template.yaml`):

```yaml
metadata:
  name: <folder>_index
  folder: <folder_path>
  purpose: <from _meta.yaml or inferred>
  updated: "YYYY-MM-DD"

files:
  - path: <full/path/to/file>
    summary: <brief description>
    keywords: [keyword1, keyword2]
    type: document | config | code | data
    priority: high | medium | low
    updated: YYYY-MM-DD

related:
  - _indices/master.yaml
```

## Naming Convention
- `docs_index.yaml` for `_docs/` folder
- `specs_tech_index.yaml` for `specs/tech/` folder
- Use underscores to replace slashes in nested paths

## Important Rules
- Read `_meta.yaml` first - it has most of the info you need
- If `_meta.yaml` lacks detail, explore folder contents directly
- Keep summaries brief (one line each)
- Infer file types from extensions: .yaml/.yml → config, .md → document, .json → data
- Always link to `_indices/master.yaml` in related section
- Update only what changed - don't rewrite unchanged files
