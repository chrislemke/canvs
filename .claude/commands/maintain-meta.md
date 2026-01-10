---
description: Update all _meta.yaml files with current folder contents
allowed-tools: Task, Read, Write, Edit, Bash, Glob, Grep
---

Maintain all _meta.yaml files in this project. $ARGUMENTS

## Your Task

1. **Find all meta files**: Use Glob to find all `_meta.yaml` files in the project

2. **For each meta file**:
   - List actual files in that directory (excluding `_meta.yaml` itself)
   - Read the current `_meta.yaml` content
   - Update these fields:
     - `primary_files`: List of actual files in the folder (most important first, limit to ~5-10 files)
     - `contains`: Infer content types from file extensions found
     - `updated`: Set to today's date in YYYY-MM-DD format
   - Preserve all other fields exactly as they are
   - Only edit if changes are actually needed

3. **Track changes**: Keep a running list of which files were updated and what changed

4. **Summary**: At the end, provide a concise summary:
   - Total meta files scanned
   - Number of files updated
   - Brief list of what was changed

## Content Type Mapping
Use these mappings when generating the `contains` field:
- `.md` files → `markdown-documentation`
- `.yaml` / `.yml` files → `yaml-configuration`
- `.json` files → `json-data`
- `.png` / `.jpg` / `.jpeg` / `.svg` / `.gif` files → `images`
- `.pdf` files → `pdf-documents`
- `.txt` files → `text-files`
- Subdirectories → `subfolders`

## Important Rules
- Do NOT modify: `purpose`, `keywords`, `ai_guidance`, `related`, `category`, or `priority`
- Only update files where actual changes are needed (skip if already up-to-date)
- Use Edit tool for targeted field updates, not full file rewrites
- Keep processing efficient - batch operations where possible
- Exclude `_meta.yaml` from `primary_files` list
