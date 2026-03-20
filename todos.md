# solyshi-workstation — Todos

## 🔴 High Priority

- [ ] **Lockscreen einrichten** — kein Lockscreen aktiv (z.B. hyprlock)
- [ ] **Rofi Theming** — matugen-Farben greifen nicht konsistent, UI unfertig

## 🟡 Medium Priority

- [ ] **Waybar erweitern** — Netzwerk-Modul, Datum, weitere Module nach Bedarf
- [ ] **Quickshell vs. Widgets entscheiden** — vorerst bei Waybar bleiben, später evaluieren
- [ ] **Zsh Config aufräumen** — Plugins, Aliase, XDG-Pfade prüfen und dokumentieren
- [ ] **Hyprland Config aufräumen** — Animationen, Gaps, Dekorationen finalisieren
- [ ] **Kitty Config finalisieren** — Padding gesetzt, Farben aktiv — noch: Font-Größe, Tab-Bar

## 🟢 Nice to have / Langfristig

- [ ] **Qutebrowser** — Einarbeiten oder durch anderen Browser ersetzen (z.B. Firefox mit Tiling)
- [ ] **Delayed Wallpaper Fix** — Wallpaper-Wechsel Mechanismus via hyprpaper verbessern
- [ ] **Automatisches Mounten** — /mnt/archive und /mnt/backup beim Boot via fstab/udev
- [ ] **Spicetify** — Spotify Theming mit matugen-Farben
- [ ] **SDKMAN Pfad** — prüfen ob XDG_DATA_HOME Pfad nach Neuinstallation korrekt gesetzt wird

## ✅ Erledigt

- [x] Mako Config gefixt (source= Direktive entfernt, per stow verlinkt)
- [x] Kitty matugen-Farben aktiv (include colors.conf), Padding gesetzt
- [x] Waybar Pills-Styling (rgba Hintergrund, blur via layerrules)
- [x] Hyprland layerrules.conf erstellt und eingebunden
- [x] SDKMAN Pfad repariert (doppeltes .sdkman Verzeichnis bereinigt)
- [x] Timeshift eingerichtet (wöchentlich, /mnt/archive, rsync-Modus)
- [x] systemd-boot dauerhaft auf linux-lts gesetzt
- [x] NetworkManager Autostart bestätigt
- [x] System aufgeräumt (verwaiste Pakete, WLAN-Treiber-Reste, wpa_supplicant Config)
- [x] .gitignore für qutebrowser Auto-Dateien
- [x] grim + slurp installiert (Screenshot-Tool)
- [x] tmux installiert und konfiguriert
- [x] **windowrules.conf in hyprland.conf einbinden** — Datei existiert, aber kein `source =` Eintrag
EOF
