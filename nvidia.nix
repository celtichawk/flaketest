# nvidia.nix
{ config, pkgs, ... }:

{
  # 1. Allow unfree packages (if not set globally)
  nixpkgs.config.allowUnfree = true;

  # 2. Tell NixOS to load the NVIDIA kernel module for graphics
  services.xserver.videoDrivers = [ "nvidia" ];

  # 3. Hardware Graphics (OpenGL / Vulkan) settings
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Critical for Steam and 32-bit Unity games
  };

  # 4. NVIDIA Driver specific configuration
  hardware.nvidia = {
    # Modesetting is MANDATORY for Wayland compositors like Niri to function
    modesetting.enable = true;

    # Power management can cause wake-from-sleep issues on desktops; keep disabled
    powerManagement.enable = false;
    powerManagement.finegrained = false;

    # NVIDIA Open-Source Kernel Modules
    # Recommended for Turing (RTX 2000) and newer desktop cards
    open = true;

    # Enable the nvidia-settings GUI app
    nvidiaSettings = true;

    # Uses the latest stable driver set matching your kernel
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
