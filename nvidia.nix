# nvidia.nix
{ config, pkgs, ... }:

{
  # 1. Allow unfree packages for NVIDIA drivers and CUDA toolkits
  nixpkgs.config.allowUnfree = true;

  # 2. Add NVIDIA driver module
  services.xserver.videoDrivers = [ "nvidia" ];

  # 3. Hardware Graphics (OpenGL / Vulkan)
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Critical for Steam and 32-bit games
  };

  # 4. NVIDIA Driver Configuration
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = true; # Open kernel modules for modern RTX series
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # 5. CUDA Binary Cache Configuration (prevents hours of compiling on unstable)
  nix.settings = {
    substituters = [
      "https://cache.nixos-cuda.org"
    ];
    trusted-public-keys = [
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
    ];
  };

  # 6. Wayland & Driver Session Variables for Niri
  environment.sessionVariables = {
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    LIBVA_DRIVER_NAME = "nvidia";
    NIXOS_OZONE_WL = "1"; # Modern Wayland support for Electron/Brave apps
  };

  # 7. GPU-Accelerated LLM Backend & CUDA utilities
  environment.systemPackages = [
    (pkgs.koboldcpp.override { config.cudaSupport = true; })
    pkgs.cudaPackages.cudatoolkit
    pkgs.clinfo
  ];
}