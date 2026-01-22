# qutebrowser configuration
# GPU acceleration fix for amd on wayland

config.load_autoconfig(False)

c.qt.force_software_rendering = False

c.qt.args = [
    "--use-gl=desktop",
    "--disbale-angle",
    "--enable-gpu-rasterization",
    "--ignore-gpu-blocklist",
]
