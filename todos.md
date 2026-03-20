# solyshi-workstation — Todos

## 🔴 High Priority

- [ ] **Lockscreen einrichten** — kein Lockscreen aktiv (hyprlock + hypridle)
- [ ] **Rofi Theming** — matugen-Farben greifen nicht konsistent, UI unfertig

## 🟡 Medium Priority

- [ ] **Vim-Tmux-Navigator** — `Ctrl+h/j/k/l` nahtlos zwischen Nvim und Tmux
- [ ] **tmux-resurrect + tmux-continuum** — Session-Persistenz nach Reboot
- [ ] **Harpoon** — Datei-Navigation via `Alt+1/2/3/4` in Nvim
- [ ] **vim-tmux-runner (VTR)** — Befehle aus Nvim an Tmux-Pane senden
- [ ] **Zsh Config aufräumen** — Plugins, Aliase, XDG-Pfade prüfen und dokumentieren
- [ ] **Hyprland Config finalisieren** — Animationen, Dekorationen feintunen
- [ ] **Kitty Config finalisieren** — Font-Größe, Tab-Bar Styling
- [ ] **Screenshot-Keybind** — grim + slurp in Hyprland einbinden

## 🟢 Nice to have / Langfristig

- [ ] **Qutebrowser** — Einarbeiten oder durch anderen Browser ersetzen
- [ ] **Delayed Wallpaper Fix** — Wallpaper-Wechsel Mechanismus verbessern
- [ ] **Spicetify** — Spotify Theming mit matugen-Farben
- [ ] **Waybar erweitern** — weitere Module nach Bedarf
- [ ] **Quickshell** — später als Waybar-Alternative evaluieren
- [ ] **SDKMAN Pfad** — nach Neuinstallation XDG_DATA_HOME Pfad prüfen

## ✅ Erledigt

- [x] Mako Config gefixt (source= Direktive entfernt, per stow verlinkt)
- [x] Kitty matugen-Farben aktiv (include colors.conf), Padding + placement_strategy gesetzt
- [x] Neovim Hintergrund auf none (nahtloses Terminal-Padding)
- [x] Waybar Pills-Styling (rgba Hintergrund, blur via layerrules)
- [x] Hyprland layerrules.conf erstellt und eingebunden
- [x] windowrules.conf in hyprland.conf eingebunden
- [x] Keybinds konsolidiert in keybinds/main.conf
- [x] Scratchpads eingerichtet (Spotify, Vesktop, Terminal)
- [x] Workspace-Zuweisungen (qutebrowser→2, dolphin→3, thunderbird→9)
- [x] Smart Gaps aktiviert
- [x] tmux-sessionizer eingerichtet (Zsh + Tmux + Hyprland Integration)
- [x] SDKMAN Pfad repariert (doppeltes .sdkman Verzeichnis bereinigt)
- [x] Timeshift eingerichtet (wöchentlich, /mnt/archive, rsync-Modus)
- [x] systemd-boot dauerhaft auf linux-lts gesetzt
- [x] fstab nofail für /mnt/backup gesetzt
- [x] NetworkManager Autostart bestätigt
- [x] System aufgeräumt (verwaiste Pakete, WLAN-Treiber-Reste, wpa_supplicant Config)
- [x] .gitignore für qutebrowser Auto-Dateien
- [x] grim + slurp installiert
- [x] Screenshot-Keybinds eingerichtet (grim + slurp)
- [x] Autostart Apps auf Workspaces (kitty, qutebrowser, thunderbird)
- [x] Workspace-Layout finalisiert und konsistent indexiert
- [x] Bootstrap Script erstellt (interaktiv, dry-run, reproduzierbar)
- [x] Package-Listen restrukturiert (01-04)
