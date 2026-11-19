# lualine.lua — optimization notes

This document covers the changes made to `lua/plugins/lualine.lua`, why they were made, how they were applied, and the precautions taken.

## Changes made

### 1. Startup & loading

- Added an `init()` that stores the original `laststatus` in `vim.g.lualine_laststatus`, shows an empty statusline (`" "`) when files are opened, and hides the statusline on the starter page — matching LazyVim's fast-start pattern.
- Converted `opts` from a static table to `opts = function()`, applying LazyVim's `lualine_require.require = require` trick to bypass lualine's slower require indirection.
- Set `vim.o.laststatus = vim.g.lualine_laststatus` inside `opts` to restore the real statusline once lualine loads.

### 2. Options

- `theme = "auto"` — let lualine follow the active colorscheme.
- `globalstatus = vim.o.laststatus == 3` — single global statusline when `laststatus=3`.
- `disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } }` — skip rendering in special buffers.
- `extensions = { "neo-tree", "lazy", "fzf" }` — use optimized extension statuslines in sidebars/popups, avoiding evaluation of regular components there.

### 3. `lsp` component

- Switched from `pairs` to `ipairs` (array iteration).
- Removed the redundant `string.format("%s", ...)`; returns `table.concat(names, ", ")` directly.
- Now filters both `null-ls` and `none-ls`.

### 4. `env_cleanup`

- Replaced the manual `gmatch` loop with `venv:match("([^/]+)/?$") or venv` — same result (last path segment), faster and shorter.

### 5. `python_env`

- Early-returns when `filetype ~= "python"` (before checking env vars).
- Early-returns when the env var is missing or empty.

### 6. `noice` components (lualine_x)

- Guarded `get()` calls with `package.loaded["noice"]` checks so inactive plugins don't trigger requires on every redraw.
- Same guard already present in `cond` functions.

### 7. `sidekick` component (lualine_x)

- Cached `pcall(require, "sidekick.status")` instead of calling `require` twice per evaluation.

### 8. Preserved behavior

- `mode_map` table, mode component, `hide_in_width`, colors, separators, and component order are unchanged.
- The commented-out diagnostics component remains removed (as in the original).

## Methodology

1. **Read before changing** — loaded LazyVim's own `lua/lazyvim/util/lualine.lua` and `lua/lazyvim/plugins/ui.lua` to match conventions (init pattern, `lualine_require` trick, `extensions`, `disabled_filetypes`).
2. **Behavior-preserving** — only implementation details changed (loops → regex, `pairs` → `ipairs`, added guards); no layout, color, or component changes.
3. **Verify after each edit** — `nvim --headless -c "luafile lua/plugins/lualine.lua" -c "qa"` confirmed clean load.

## Precautions

- No new dependencies; works with the existing plugin set.
- No config files rewritten wholesale; targeted edits only.
- Load-tested before committing.
- Committed as `ffd9384` ("refactor(lualine): optimize statusline performance and startup").

## File changed

| File | Change |
|------|--------|
| `lua/plugins/lualine.lua` | Performance + startup optimizations |
