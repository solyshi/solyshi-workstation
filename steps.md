# solyshi-workstation — Setup Protocol

Vollständiges Installationsprotokoll des solyshi Arch Linux Workstation-Setups.
Kernel: linux-lts | WM: Hyprland | Shell: Zsh | Terminal: Kitty

---

## 1. Basis-System

```bash
sudo systemctl enable --now NetworkManager
```

- Base-Pakete: `base base-devel linux linux-lts linux-firmware linux-headers linux-lts-headers`
- Boot: systemd-boot (kein GRUB), LTS als Standard-Eintrag in `/boot/loader/loader.conf`
- AUR-Helper: yay
  ```bash
  git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
  yay -Y --gendb && yay -Syu --devel && yay -Y --devel --save
  ```

---

## 2. Build-Toolchain

```bash
sudo pacman -S base-devel gcc make fakeroot debugedit meson ninja pkg-config cmake
```

---

## 3. Wayland & Compositor

```bash
sudo pacman -S wayland wayland-protocols xorg-xwayland
yay -S hyprland xdg-desktop-portal xdg-desktop-portal-hyprland
sudo pacman -S xdg-user-dirs xdg-utils
```

- Hyprland-Autostart in `.zprofile` (nicht `.zshrc`)
- Keyboard-Layout: `de` in Hyprland input.conf
- Monitore: DP-3 (primary), konfiguriert in hyprpaper.conf

---

## 4. Shell & Terminal

```bash
sudo pacman -S zsh kitty
chsh -s /bin/zsh
```

- Oh-My-Zsh via curl-Installer
- Plugins: zsh-autosuggestions, zsh-syntax-highlighting (beide als git clone in ~/.oh-my-zsh/custom)
- Theme: Powerlevel10k
  ```bash
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
  ```
- Kitty: Padding 12px, `placement_strategy center`, matugen-Farben via `include colors.conf`

---

## 5. Dotfiles (stow)

```bash
git clone git@github.com:Chri1899/solyshi-workstation.git ~/solyshi-workstation
stow -d ~/solyshi-workstation/dotfiles -t ~ $(cat ~/solyshi-workstation/profiles/desktop.stow)
```

Profile: `nvim kitty hypr qutebrowser emacs waybar assets zsh matugen rofi theme dolphin mako tmux scripts`

---

## 6. Fonts

```bash
sudo pacman -S ttf-jetbrains-mono ttf-jetbrains-mono-nerd ttf-fira-code ttf-hack
```

---

## 7. Hardware & Grafik

```bash
sudo pacman -S mesa vulkan-radeon libva-mesa-driver vulkan-icd-loader
sudo pacman -S mesa-utils vulkan-tools
sudo pacman -S pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber
sudo pacman -S libpulse
```

---

## 8. Theming (matugen)

```bash
yay -S matugen-bin
```

- Config: `~/.config/matugen/config.toml`
- Templates für: hyprland, waybar, kitty, rofi, mako, vesktop, qutebrowser
- Ausführen: `matugen image ~/wallpapers/<wallpaper>`
- Reload: Hyprland, Kitty, Rofi, Mako werden automatisch neu geladen

---

## 9. Status Bar (Waybar)

```bash
sudo pacman -S waybar
```

- Config: `~/.config/waybar/config.jsonc`
- Style: Pills-Design mit rgba-Hintergrund, matugen-Farben via `@import "colors.css"`
- Reload-Keybind: `Super + R` → `~/.config/waybar/scripts/launch.sh`
- Hyprland layerrule für Blur: `~/.config/hypr/rules/layerrules.conf`

---

## 10. Benachrichtigungen (Mako)

```bash
sudo pacman -S mako
systemctl --user enable mako
```

- Config: `~/.config/mako/config` (Farben direkt eingebettet, kein `source=`)
- Farben werden von matugen via Template generiert und direkt in config geschrieben

---

## 11. Wallpaper (hyprpaper)

```bash
yay -S hyprpaper
```

- Config: `~/.config/hypr/hyprpaper.conf`
- Wallpaper-Picker via Rofi: `Super + W`
- Wallpapers: `~/wallpapers/` (symlink via stow auf assets)

---

## 12. Launcher & Clipboard

```bash
sudo pacman -S rofi-wayland wl-clipboard cliphist
```

- Rofi: `Super + A` (drun), `Super + V` (clipboard via cliphist)
- Clipboard-Integration in Hyprland autostart

---

## 13. Editoren

```bash
sudo pacman -S neovim vim
```

- Neovim: Config per stow verlinkt (`~/.config/nvim`)
- Neovim Hintergrund auf `none` gesetzt für nahtloses Terminal-Padding
- Plugins via luarocks, tree-sitter-cli, ripgrep, fd

---

## 14. Entwicklungsumgebung

### Java / JVM
```bash
yay -S sdkman-bin
# SDKMAN_DIR muss in .zshrc auf $XDG_DATA_HOME/sdkman zeigen
sdk install java 21.0.9-tem
sdk install java 25.0.0-tem   # optional
sdk install gradle 9.x.x
sdk install maven 3.x.x
```
⚠️ Hinweis: SDKMAN installiert sich in `$SDKMAN_DIR/.sdkman/` — Pfad nach Installation prüfen und ggf. Inhalt eine Ebene nach oben verschieben.

### Node.js / Frontend
```bash
sudo pacman -S nodejs npm pnpm typescript
```

### Python
```bash
sudo pacman -S python python-pip
```

### Rust
```bash
sudo pacman -S rust
```

### Datenbank
```bash
sudo pacman -S postgresql
sudo -iu postgres initdb --locale en_US.UTF-8 -D /var/lib/postgres/data
sudo systemctl enable --now postgresql
```

### Sonstige Dev-Tools
```bash
sudo pacman -S git openssh tmux fzf ripgrep fd tree-sitter-cli luarocks
sudo pacman -S man-db man-pages
```

---

## 15. Anwendungen

```bash
yay -S qutebrowser
sudo pacman -S gst-plugins-{base,good,bad,ugly} gst-libav  # Video-Unterstützung

yay -S vesktop          # Discord
yay -S tradingview
sudo pacman -S libreoffice-fresh
sudo pacman -S thunderbird
yay -S spotify
sudo pacman -S dolphin
sudo pacman -S steam
yay -S prismlauncher    # Minecraft
yay -S ausweisapp2
```

---

## 16. System-Stabilität

### Snapshots (Timeshift)
```bash
sudo pacman -S timeshift
```
- Modus: rsync (kein btrfs)
- Ziel: `/mnt/archive` (UUID: 3f855919-60d7-4682-83b4-27523566ba9a)
- Schedule: wöchentlich, 2 Snapshots
- Ausschlüsse: `/mnt/**`, `/tmp/**`, `/var/log/**`, `/var/cache/pacman/pkg/**`, `/home/solyshi/**`

### systemd-boot LTS
```bash
# /boot/loader/loader.conf
default 2026-01-20_20-56-11_linux-lts.conf
timeout 3
```

### fstab — nofail für externe Disks
Alle HDDs/SSDs die nicht zwingend beim Boot verfügbar sein müssen mit `nofail` mounten:
```
UUID=xxxx /mnt/backup ext4 defaults,nofail 0 2
```
Verhindert Emergency Mode bei nicht verfügbaren Geräten.

---

## 17. Hyprland — Scratchpads & Workspace Rules

- Workspace-Zuweisungen: qutebrowser→WS2, dolphin→WS3, thunderbird→WS9
- Scratchpads: Spotify (`Super+Shift+M`), Vesktop (`Super+Shift+D`), Terminal (`Super+Shift+T`)
- Script: `~/.config/hypr/scripts/toggle-scratch-term.sh` für Terminal-Scratchpad
- Smart Gaps aktiviert: einzelnes Fenster füllt Screen ohne Gaps/Border
- Keybinds konsolidiert in `keybinds/main.conf`
- `windowrules.conf` und `layerrules.conf` in `hyprland.conf` eingebunden
- Autostart: kitty→WS1, qutebrowser→WS2, thunderbird→WS9 (silent)
- Screenshot-Keybinds: Print (fullscreen), Shift+Print (Bereich), Ctrl+Print (Clipboard)
- Screenshots gespeichert in `~/Pictures/Screenshots/`
- Workspace-Layout: WS1 kitty, WS2 qutebrowser, WS3 dolphin (manuell), WS9 thunderbird, WS10 tradingview (manuell)
- Autostart Apps: kitty→WS1, qutebrowser→WS2, thunderbird→WS9 (silent)
- TradingView windowrule: workspace 10 (Super+0)

---

## 18. Tmux — Sessionizer & Workflow

### tmux-sessionizer
Dynamisches Projekt-Management-Skript — sucht in `~/solyshi-workstation` und `~/projects` nach Ordnern, zeigt sie via fzf mit Live-Vorschau.

- Existierende Session → `switch-client`
- Neue Session → `new-session`
- Pfad: `~/solyshi-workstation/dotfiles/scripts/scripts/tmux-sessionizer` (via stow nach `~/scripts/` verlinkt)

### Hotkey-Integration (3 Ebenen)
- **Zsh** `Ctrl+F` — Sessionizer direkt aus der Shell
- **Tmux** `Prefix+F` — Sessionizer als zentriertes Popup (Wechsel während Programme laufen)

### Roadmap (noch nicht umgesetzt)
- [ ] **Vim-Tmux-Navigator** — `Ctrl+h/j/k/l` nahtlos zwischen Nvim-Splits und Tmux-Panes
- [ ] **tmux-resurrect + tmux-continuum** — Session-Persistenz nach Reboot
- [ ] **Harpoon** — schnelles Springen zwischen Projekt-Dateien via `Alt+1/2/3/4`
- [ ] **vim-tmux-runner (VTR)** — Befehle aus Nvim an Tmux-Pane senden

---

## 19. Offene Punkte

Siehe `todos.md`
