1. sudo systemctl enable NetworkManager
2. sudo systemctl start NetworkManager
3. ( Create base repo for workstation config setup )
4. sudo pacman -S vim
5. Install fakeroot and debugedit
7. Install make and gcc
6. Install yay
    - git clone https://aur.archlinux.org/yay.git
    - cd yay
    - makepkg -si
7. Run those command once after install:
    - yay -Y --gendb
    - yay -Syu --devel
    - yay -Y --devel --save
8. Install meson and ninja
9. Install pkg-config
10. Install wayland
11. yay -S wayland-protocols
12. yay -S xorg-xwayland
13.  yay -S hyprland
14. yay -S kitty
15. yay -S openssh
16. ssh-keygen
17. Install zsh
18. chsh -s /bin/zsh
19. Added autostart for hyprland to .zshrc
20. Installed libinputs
21. Installed ttf-jetbrains-mono
22. Switched Hyprland keyboard layout to de
23. Installed qutebrowser and added keybind to hypr conf
24. Connected SSH to github and cloned .dotfiles
25. Integrate dotfiles with a stow workflow. Use:
    cd ~
    stow -d ~/solyshi-workstation/dotfiles -t ~ $(cat ~/solyshi-workstation/profiles/desktop.stow) 
26. yay -S gst-plugins-{base,good,bad,ugly} gst-libav (for qutebrowser video playback)
27. yay -S xdg-desktop-portal (??)
28. Moved hyprland autostart to .zprofile and added zsh dotfiles package
29. Installed xdg-desktop-portal-hyprland

30. Reorganized packages and installed xdg-user-dirs and xdg-utils
31. Installed mesa, vulkan-radeo, libva-mesa-driver, vulkan-icd-loader
32. Installed mesa-utils and vulkan-tools
33. Install nerd font jetbrains mono
34. Installed neovim
35. Installed wget, curl, zip, unzip and tar
36. Installed fzf
37. Installed luarocks, tree-sitter-cli, ripgrep, fd,
38. Installed nodejs, npm, pnpm
39. Installed cargo
40. Installed python3
41. Installed sdkman
42. Installed jdk25 and 21 with sdk install java "version" (21.xx.xx-tem and 25.x.x-tem)
43. sdk install gradle 9.x.x
44. sdk install maven 3.12.x
45. Default qutebrowser config + dark mode
46. Installed oh-my-zsh (github curl) and added autocompleteplugin (github clone)
47. Installed zsh-syntax-highlighting git clone into .oh-my-zsh
48. Installed powerlevel10k git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
49. Installed man and zsh colored-man-pages
50. Installed hyprpaper, set the wallpapers and configured monitors in hypr
51. Installed waybar and matugen
52. Made a waybar reload script with hypr keybinding
53. Fixed mislocation in wallpaper module
54. Enabled ipc on hypr and made a simple matugen config.
55. Some untracked little hypr changes and matugen support 
56. Tinkering with fonts, installed fira font
59. More rofi configuration. First iteration done for now
60. Installed mako
61. Installed wl-clipboard and cliphist and integrated to hyprland
62. Installed Vesktop and Tradingview
63. Addes postgresql to dev packs
64. sudo -iu postgres initdb --locale en_US.UTF-8 -D /var/lib/postgres/data
65. sudo systemctl enable --now postgresql
66. yay -S libreoffice
67. Added thunderbird, added personal .de, personal .com samvanced dev, info and personal samvanced mail
68. Installed spotify and keybind in hypr
69. Reorganized theming and implemented a rofi background picker
70. yay -S dolphin
71. Added dolphin stow
72. Made some more unifications for color schemes
73. Installed tmux
74. Installed tailwind lsp
