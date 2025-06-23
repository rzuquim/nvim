## 🏆 Improvements

- [x] **2025-05-30**: close browser when leaving nvim
- [x] **2025-05-30**: do not focus on browser on md preview (~/.config/hypr/\_window_rules.conf)
- [ ] **2025-05-30**: sync browser navigation when changing focused md file (following links)
- [ ] **2025-05-30**: smart order on markdown actions (eg. First action should be start preview if not already running)

##  Bugs

- [x] **2025-04-29**: `beautysh` not working `ModuleNotFoundError: No module named 'pkg_resources'`

```bash
# beautysh was missing the setuptools package (an issue on Mason?)
source ~/.local/share/nvim/mason/packages/beautysh/venv/bin/activate
pip install setuptools
deactivate
```

- [x] **2025-04-29**: `+` and `-` keybindings not incrementing not working sporadically

```text
my zsa keyboard map was using numpad+ and - instead of the regular ones
```

- [ ] **2025-04-30**: retire `dressing.nvim` in favor of `https://github.com/folke/snacks.nvim/blob/main/docs/input.md`
- [x] **2025-04-30**: today "macro"
- [x] **2025-04-30**: enter on md should not create link (transform in "LSP Action")
- [x] **2025-04-30**: navigate to link on md should run in "go to definition" shortcut
- [x] **2025-04-30**: remove snippets from LSP Servers
- [x] **2025-05-01**: emojis
- [ ] **2025-05-02**: support markdown tables
- [x] **2025-05-02**: markdown preview
- [ ] **2025-05-30**: quotes and code blocks not rendering on first live-preview render
