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
