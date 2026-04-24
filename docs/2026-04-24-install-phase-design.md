# Install Phase Redesign — Design Spec
*2026-04-24*

## Overview

Redesign `install/bootstrap.sh` and its lib files into a 6-stage interactive wizard.
Each stage runs in a fixed order; within each stage every component is individually
confirm-prompted. Nothing is assumed — the user installs only what they want.

## Goals

- Solve the SSH chicken-and-egg problem (identity before clone)
- Add system configuration steps (locale, timezone, hostname) before package install
- Fill package list gaps (bluetooth, portals, lockscreen, display profiles, etc.)
- Remove nautilus from all install paths (not configured)
- Add hardware capability checks before optional hardware packages/services
- Add first-boot finalization (matugen initial run, TPM bootstrap, XDG dirs)
- Preserve dry-run flag throughout all stages

## Non-Goals

- GUI installer
- Profile-based presets
- Automated swapfile/zram configuration (too machine-specific, documented instead)

---

## Stages

### Stage 1: Identity & Auth
**New file:** `install/lib/identity.sh`
**Runs before:** the repo clone check in `bootstrap.sh`

#### `setup_ssh()`
- Skips if `~/.ssh/id_ed25519` already exists
- Prompts for email to embed in key
- Runs `ssh-keygen -t ed25519 -C "$email" -f ~/.ssh/id_ed25519`
- Prints public key to terminal
- Pauses: *"Add this key to GitHub → Settings → SSH Keys, then press Enter"*
- Tests with `ssh -T git@github.com`, retries up to 3 times, user can skip

#### `setup_git_identity()`
- Skips if `git config --global user.name` is already set
- Prompts interactively for name and email
- Runs `git config --global user.name` and `git config --global user.email`

#### `setup_gh_auth()`
- Skips if `gh auth status` exits 0
- Runs `gh auth login --git-protocol ssh` (device code flow — no browser required)
- Verifies with `gh auth status` after completion

---

### Stage 2: System Config
**New file:** `install/lib/system.sh`
**Runs before:** package installation so locale is set before any locale-sensitive package

#### `setup_hostname()`
- Prompts for hostname input
- Runs `sudo hostnamectl set-hostname "$hostname"`

#### `setup_timezone()`
- Lists timezones via `timedatectl list-timezones | fzf` for a searchable picker
- Runs `sudo timedatectl set-timezone "$tz"`

#### `setup_locale()`
- Prompts for locale string (default: `en_US.UTF-8`, user can override)
- Uncomments the entry in `/etc/locale.gen`
- Runs `sudo locale-gen`
- Writes `LANG=$locale` to `/etc/locale.conf`

#### `print_swap_notice()`
- Always prints: *"Swap not configured — configure manually after reboot. See README §Swap."*
- No automation: swapfile vs zram choice is too machine-specific

---

### Stage 3: Packages
**Modified:** all `install/pkg/*.txt`, `install/lib/packages.sh`, `profiles/desktop.stow`

#### Package file structure (replaces old 4-file layout)

```
install/pkg/
├── 01-base.txt              # core system, boot, networking, shell tools, fonts, audio
├── 02-desktop-core.txt      # hyprland, wayland, sddm, kitty, waybar, rofi, mako,
│                            # matugen, portals (hyprland + gtk), polkit-gnome,
│                            # hyprlock, hypridle
├── 02-desktop-media.txt     # grim, slurp, wf-recorder, wlsunset
├── 02-desktop-bluetooth.txt # bluez, bluez-utils        (hardware-checked)
├── 02-desktop-brightness.txt# brightnessctl             (hardware-checked)
├── 02-desktop-display.txt   # kanshi, playerctl
├── 02-desktop-apps.txt      # qutebrowser, btop
├── 03-dev-core.txt          # gcc, make, cmake, clang, meson, ninja, bear, pkg-config,
│                            # patch, debugedit, fakeroot, vim, neovim, luarocks,
│                            # tree-sitter-cli, ripgrep, fd, tmux, tmuxinator,
│                            # zeal, gdb, lldb
├── 03-dev-langs.txt         # nodejs, npm, pnpm, typescript, python, python-pip,
│                            # rustup, sdl2
├── 03-dev-java.txt          # sdkman-bin  (handled via setup_sdkman, listed for reference)
├── 03-dev-db.txt            # postgresql
├── 03-dev-utils.txt         # yazi
├── 04-apps-comms.txt        # vesktop, thunderbird
├── 04-apps-productivity.txt # libreoffice-fresh, spotify, spicetify-cli,
│                            # timeshift-autosnap
└── 04-apps-gaming.txt       # steam, prismlauncher, ausweisapp2, mpv, tradingview
```

Each file maps to one confirm-prompt in `packages.sh`.

#### Hardware capability checks

**`install_bluetooth()`**
```
if bluetooth hardware detected (rfkill / /sys/class/bluetooth/):
    confirm "Bluetooth hardware detected. Install bluetooth support?"
else:
    warn "No Bluetooth hardware detected."
    confirm "Install bluetooth support anyway?"
```

**`install_brightness()`**
```
if /sys/class/backlight/ is non-empty:
    confirm "Install brightnessctl?"
else:
    info "No backlight found (desktop/external monitors) — skipping brightnessctl"
    # no prompt
```

#### Package additions vs current lists

| Package(s) | Added to |
|------------|----------|
| `zsh-theme-powerlevel10k` | `01-base.txt` |
| `xdg-desktop-portal-gtk` | `02-desktop-core.txt` |
| `polkit-gnome` | `02-desktop-core.txt` |
| `hyprlock`, `hypridle` | `02-desktop-core.txt` |
| `bluez`, `bluez-utils` | `02-desktop-bluetooth.txt` |
| `brightnessctl` | `02-desktop-brightness.txt` |
| `kanshi`, `playerctl` | `02-desktop-display.txt` |
| `gdb`, `lldb` | `03-dev-core.txt` |
| `timeshift-autosnap` | `04-apps-productivity.txt` |

#### Removals

| Package | Removed from |
|---------|-------------|
| `nautilus` | `02-desktop.txt` (old) — not added to any new file |

#### Stow profile (`profiles/desktop.stow`)
- Remove: `nautilus` (not configured, not added)
- Add: `emacs` — confirm-prompted during `setup_stow()`

---

### Stage 4: Services
**Modified:** `install/lib/services.sh`

#### Always enabled (no prompt)
- `NetworkManager`

#### Conditional — only offered if corresponding packages were installed

Conditions are checked via unit/command existence — no inter-stage flags needed.

| Service | Condition check |
|---------|----------------|
| `bluetooth.service` | `systemctl cat bluetooth.service &>/dev/null` |
| `fstrim.timer` | `lsblk --discard` output shows DISC-GRAN > 0 on any block device |
| `cronie` | `command -v cronie &>/dev/null` or `pacman -Q timeshift-autosnap &>/dev/null` |
| `postgresql` | confirm-prompted if `command -v psql &>/dev/null` (existing behaviour) |
| `sddm` | enabled as part of desktop install (existing) |
| `mako` (user service) | enabled as part of desktop install (existing) |

#### Hyprland autostart (`dotfiles/hypr/functionality/autostart.conf`)
These are dotfile changes, not systemd services:

| Entry | Condition |
|-------|-----------|
| `/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1` | desktop-core installed |
| `hypridle` | hyprlock/hypridle installed |
| `kanshi` | kanshi installed |

Note: `hyprlock` is invoked by `hypridle` via its config — not added directly to autostart.

---

### Stage 5: Dotfiles
**Modified:** `install/lib/dotfiles.sh`

#### `setup_stow()` changes
- Add `--no-folding` to prevent stow creating symlinked directories
- Before stowing: scan target paths for existing non-symlink files, warn and skip
  conflicts instead of exiting with an error
- `emacs` stowed only if user confirms

#### `setup_directories()` changes
- Add `xdg-user-dirs-update` call after `mkdir` commands

#### Keyboard layout patch
No change — applied after stow as today.

---

### Stage 6: First Boot
**New file:** `install/lib/firstboot.sh`

#### `setup_boot()`
- Moved from `services.sh` (it is a post-install step, not a service)
- Logic unchanged: sets LTS entry in `/boot/loader/loader.conf`

#### `setup_tpm()`
- Only offered if tmux was installed in Stage 3
- Runs `~/.tmux/plugins/tpm/scripts/install_plugins.sh` headlessly
- Skips with warning if `~/.tmux/plugins/tpm` doesn't exist after stow

#### `setup_matugen_default()`
- Only offered if matugen was installed in Stage 3
- Prerequisite: `assets/wallpaper/default.jpg` must exist in the repo
- Runs `matugen image ~/solyshi-workstation/assets/wallpaper/default.jpg`
- Without this, all themed apps start with missing color configs on first boot

#### `print_p10k_notice()`
- Prints: *"Run zsh and follow the p10k configuration wizard on first login"*

#### `print_final_summary()`
- Lists what was installed and what was skipped
- Reminds: reboot, verify SSH key on GitHub, update `monitors.conf` per machine

---

## Full File Change List

| File | Type | Change |
|------|------|--------|
| `install/bootstrap.sh` | modify | Restructure `main()` into 6-stage wizard; source new lib files |
| `install/lib/identity.sh` | **new** | SSH, git config, gh auth |
| `install/lib/system.sh` | **new** | Hostname, timezone, locale, swap notice |
| `install/lib/firstboot.sh` | **new** | TPM, matugen, p10k notice, boot entry, final summary |
| `install/lib/packages.sh` | modify | Fine-grained installs, hardware capability checks |
| `install/lib/services.sh` | modify | Conditional service enabling; remove `setup_boot` |
| `install/lib/dotfiles.sh` | modify | `--no-folding`, conflict detection, `xdg-user-dirs-update` |
| `install/lib/toolchains.sh` | none | No changes |
| `install/pkg/01-base.txt` | modify | Add `bluez`, `bluez-utils`, `zsh-theme-powerlevel10k` |
| `install/pkg/02-desktop.txt` | **delete** | Replaced by granular files |
| `install/pkg/02-desktop-core.txt` | **new** | — |
| `install/pkg/02-desktop-media.txt` | **new** | — |
| `install/pkg/02-desktop-bluetooth.txt` | **new** | — |
| `install/pkg/02-desktop-brightness.txt` | **new** | — |
| `install/pkg/02-desktop-display.txt` | **new** | — |
| `install/pkg/02-desktop-apps.txt` | **new** | — |
| `install/pkg/03-dev.txt` | **delete** | Replaced by granular files |
| `install/pkg/03-dev-core.txt` | **new** | — |
| `install/pkg/03-dev-langs.txt` | **new** | — |
| `install/pkg/03-dev-java.txt` | **new** | — |
| `install/pkg/03-dev-db.txt` | **new** | — |
| `install/pkg/03-dev-utils.txt` | **new** | — |
| `install/pkg/04-apps.txt` | **delete** | Replaced by granular files |
| `install/pkg/04-apps-comms.txt` | **new** | — |
| `install/pkg/04-apps-productivity.txt` | **new** | — |
| `install/pkg/04-apps-gaming.txt` | **new** | — |
| `profiles/desktop.stow` | modify | Remove `nautilus`; `emacs` added conditionally |
| `dotfiles/hypr/functionality/autostart.conf` | modify | Add polkit agent, hypridle, kanshi |
| `README.md` | modify | Add §Swap, update §Installation for new wizard flow |
| `assets/wallpaper/default.jpg` | **new** | Default wallpaper required for matugen first run |

---

## Prerequisites Before Merging

- A default wallpaper must be added at `assets/wallpaper/default.jpg`
