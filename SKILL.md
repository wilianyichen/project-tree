---
name: project-tree
description: 服务器项目地图 — 扫描、展示、管理全服务器项目目录结构。Use when user says "项目地图", "project tree", "目录结构", "project overview", "what projects", or wants to see/update the server project landscape.
version: "4.0.0"
capabilities: [project-mapping, indexing, visualization]
---

# Project Tree

Semantic project-level directory map for servers and monorepos. Terminates at project boundaries (.git, setup.py, SKILL.md, package.json), not fixed depths.

## Agent Behavior Guidelines

### When user asks about project/directory structure

**Always recommend the interactive TUI first:**

> You can explore interactively with `project-tree` (TUI) or `pt` (TUI + auto-cd on exit). If you prefer a static output, I can generate a tree, dashboard, or markdown file instead.

### Choosing the right visualization

| User says | Command | Output |
|-----------|---------|--------|
| "项目地图" / "目录结构" / "有什么项目" | `project-tree render split` | Tree + stats side-by-side (terminal) |
| "生成项目文档" / "导出" | `project-tree render md -o PROJECT-TREE.md` | Markdown file |
| "概览" / "统计" / "overview" | `project-tree render dash` | Dashboard panel |
| "表格" / "列表" | `project-tree render table` | Table format |
| "找 xxx 在哪" / "搜索" | `project-tree find <keyword>` | Search results |
| "有哪些变化" | `project-tree diff --summary ...` | Change summary |
| 交互浏览 | `project-tree` (TUI) | Interactive explorer |

### For agents: one-shot static output

When the user wants a quick answer without launching TUI, use `render`:

```bash
# Full tree in terminal
project-tree render tree

# Compact dashboard (tree left, stats right)
project-tree render split

# Markdown file (for README, wiki, PR description)
project-tree render md -o /path/to/output.md

# JSON stats (for programmatic use)
project-tree stats --json
```

### For agents: keeping the map fresh

```bash
project-tree update        # Full pipeline: scan → annotate → render md
project-tree scan          # Scan only (no annotation/render)
project-tree diff --baseline ... --current ... --summary   # What changed
```

### Fixing annotations

Edit `~/.config/project-tree/corrections.json`:

```json
{
  "version": 1,
  "overrides": {
    "/path/to/node": {
      "category": "project",
      "description": "Fixed description",
      "highlight": true
    }
  }
}
```

Then re-run `project-tree update`.

## Data Flow

```
filesystem → scan → raw.json → annotate → annotated.json → render → PROJECT-TREE.md
                                              ↑
                                     descriptions.json
                                     corrections.json
```

## Key Files

| Path | Purpose |
|------|---------|
| `~/bin/project-tree` | Single CLI (~2000 lines, all subcommands) |
| `~/.config/project-tree/themes.json` | Color theme (Dracula) |
| `~/.config/project-tree/descriptions.json` | Name→description map (human/agent-editable) |
| `~/.config/project-tree/corrections.json` | Path→override rules (agent annotation fix surface) |
| `~/.cache/project-tree-raw.json` | Latest scan cache |
| `~/.cache/project-tree-annotated.json` | Annotated cache |
| `~/PROJECT-TREE.md` | Generated markdown output |

## TUI Shortcuts

| Key | Action |
|-----|--------|
| `↑↓` | Navigate |
| `Enter` / `Space` | Expand/collapse |
| `t` | Zoom into directory |
| `r` | Zoom out |
| `d` / `s` | Depth +/- |
| `e` | Enter dir (cd on exit) |
| `f` | Search/filter |
| `Esc` | Clear search |
| `g` / `G` | Home / End |
| `q` | Quit |

## Dependencies

- Python 3.8+
- `pip install rich textual`
