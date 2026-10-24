# Plugin & Package Recommendations

Candidates that fit the existing workflow: C/C++ projects (emulators, bytecode VM,
rasterizer), web APIs, Java, Python via uv, Rust, PostgreSQL + Docker, and the
tmuxinator-based sessionizer. Nothing here is installed yet; already present tools
(zoxide, eza, delta, lazygit, direnv, uv, …) are left out on purpose.

**Start here:** vim-dadbod, overseer.nvim + just, ccache — they close the most
obvious gaps.

---

## Neovim

### High impact

| Plugin | Why it fits |
|---|---|
| [vim-dadbod](https://github.com/tpope/vim-dadbod) + [vim-dadbod-ui](https://github.com/kristijanhusak/vim-dadbod-ui) | PostgreSQL is installed but there is no DB client in the editor. Run queries from a buffer, results as a table. |
| [kulala.nvim](https://github.com/mistweaverco/kulala.nvim) | HTTP client using `.http` files (Postman in the editor). Fits the API projects; request files can live in the repo. |
| [overseer.nvim](https://github.com/stevearc/overseer.nvim) | Task runner for make/cmake/npm/cargo/just. Errors land in quickfix, which trouble already opens (`<leader>xQ`). Lighter than the removed cmake-tools and build-system agnostic. |
| [neotest](https://github.com/nvim-neotest/neotest) | Run tests in the editor with adapters for pytest, Rust, Java and Jest; results as signs, debuggable via nvim-dap. |

### Smaller additions

| Plugin | Why it fits |
|---|---|
| [nvim-dap-virtual-text](https://github.com/theHamsta/nvim-dap-virtual-text) | Shows variable values inline while debugging — useful for emulator/VM code with codelldb. |
| [rustaceanvim](https://github.com/mrcjkb/rustaceanvim) | Replaces plain `rust_analyzer` with runnables, macro expansion and debugging via the already installed codelldb. |
| [nvim-treesitter-context](https://github.com/nvim-treesitter/nvim-treesitter-context) | Sticky header for the current function/class; great in long C files (e.g. an opcode dispatch loop). |
| [mini.ai](https://github.com/nvim-mini/mini.ai) | Extra `a`/`i` textobjects (arguments, function calls, quotes). Pairs with the existing mini.surround. |
| [flash.nvim](https://github.com/folke/flash.nvim) | Jump anywhere visible in 2–3 keystrokes. Natural next step after hml/precognition and the disabled arrow keys. |
| [persistence.nvim](https://github.com/folke/persistence.nvim) | Per-directory buffer sessions. Combined with the sessionizer, switching projects restores where you left off. |

---

## CLI packages

| Package | Why it fits |
|---|---|
| `ccache` | Much faster C/C++ rebuilds with cmake + ninja. Set `-DCMAKE_CXX_COMPILER_LAUNCHER=ccache` once. |
| `valgrind` | Memory errors and leaks in VM/emulator code. Alternative at zero cost: debug builds with `-fsanitize=address,undefined`. |
| `lazydocker` | lazygit for Docker; docker and docker-compose are installed without a UI. |
| `just` | Simple per-project task runner (`just run`, `just test`). Fits tmuxinator, and overseer can read justfiles. |
| `atuin` | Better `Ctrl-R`: full-text, per-directory zsh history search with stats. |
| `tealdeer` | `tldr <cmd>` gives short examples instead of full man pages; complements Zeal. |
| `difftastic` | Syntax-aware diffs. Not a delta replacement — use as `git difftool` for large refactors. |

---

## Desktop

| Package | Why it fits |
|---|---|
| `hyprpicker` | Wayland color picker, handy when tweaking matugen templates. |
| `satty` | Screenshot annotation after grim/slurp; one keybind for select → annotate → clipboard. |
