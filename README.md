# project-tree

Semantic project-level directory map for servers and monorepos.

Stops at **project boundaries** (`.git`, `setup.py`, `SKILL.md`, `package.json`) — not at fixed directory depths. Built for AI agents and humans who need to understand "what lives where" on a server.

## Install

```bash
git clone https://github.com/wilianyichen/project-tree.git
cd project-tree
./install.sh
```

The installer:
- Symlinks `bin/project-tree` → `~/bin/project-tree`
- Copies configs to `~/.config/project-tree/` (never overwrites)
- Installs Claude Code skill to `~/.claude/skills/project-tree/`
- Adds `pt()` shell function to `~/.bashrc`

Requirements: Python 3.8+, `pip install rich textual`

## Usage

### Interactive TUI

```bash
project-tree          # Launch TUI
pt                    # TUI + auto-cd on exit (press e)
```

| Key | Action |
|-----|--------|
| `↑↓` | Navigate |
| `Enter`/`Space` | Expand/collapse |
| `t` | Zoom into directory |
| `r` | Zoom out |
| `d`/`s` | Depth +/- |
| `e` | Enter dir (cd) |
| `f` | Search |
| `q` | Quit |

### CLI Subcommands

```bash
project-tree update                  # Full pipeline: scan → annotate → render md
project-tree scan                    # Scan filesystem → raw JSON
project-tree annotate                # Apply heuristics + corrections
project-tree render tree|table|dash  # One-shot terminal render
project-tree render split            # Tree + stats side-by-side
project-tree render md -o MAP.md     # Markdown output
project-tree stats                   # Summary statistics
project-tree find <name>             # Query by name/category/type
project-tree diff --baseline ...     # Compare scans
```

### Fix Annotations

Edit `~/.config/project-tree/descriptions.json` for name→description mappings, or `corrections.json` for path-level overrides:

```json
{
  "version": 1,
  "overrides": {
    "/home/user/my-project": {
      "category": "project",
      "description": "My main project",
      "highlight": true
    }
  }
}
```

Then re-run `project-tree update`.

## How It Works

```
filesystem → scan → raw.json → annotate → annotated.json → render → PROJECT-TREE.md
                                              ↑
                                     descriptions.json
                                     corrections.json
```

- **Scan** (depth 4): walks filesystem, stops at project markers, files >50-children dirs as data
- **Annotate**: heuristic classification (project/workspace/data/tool) + JSON-based corrections overlay
- **Render**: tree, table, dashboard, split-panel, or markdown

## Config

`~/.config/project-tree/watch-dirs.conf` (optional, auto-detects HOME + common mount points if absent):

```bash
WATCH_ROOTS=(
    "$HOME|~"
    "/data|/data"
)
SKIP_NAMES=("Downloads" "snap" ".cache")
MAX_DEPTH=4
```

## Themes

Dracula (default). Customize at `~/.config/project-tree/themes.json`.

## License

MIT
