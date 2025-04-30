##  Bugs

- [x] **2025-04-29**: `beautysh` not working `ModuleNotFoundError: No module named 'pkg_resources'`

```bash
# beautysh was missing the setuptools package (an issue on Mason?)
source ~/.local/share/nvim/mason/packages/beautysh/venv/bin/activate
pip install setuptools
deactivate
```

- [ ] **2025-04-29**: `+` and `-` keybindings not incrementing
- [ ] **2025-04-30**: retire `dressing.nvim` in favor of `https://github.com/folke/snacks.nvim/blob/main/docs/input.md`
