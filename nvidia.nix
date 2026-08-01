# nvidia.nix
{ config, pkgs, ... }:

{
  # 1. Enable CUDA support across nixpkgs (allowUnfree is already in configuration.nix)
  nixpkgs.config.cudaSupport = true;

  # 2. Register the NVIDIA video driver module
  services.xserver.videoDrivers = [ "nvidia" ];

  # 3. Add 32-bit graphics support (enable = true is already in configuration.nix)
  hardware.graphics.enable32Bit = true;

  # 4. Driver settings tailored for RTX 50-series / 40-series
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = true; # Open kernel modules work great for modern desktop cards
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };

  # 5. CUDA Binary Cache setup
  nix.settings = {
    substituters = [
      "https://cache.nixos-cuda.org"
    ];
    trusted-public-keys = [
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
    ];
  };

  # 6. Session Variables for Niri / Wayland
  environment.sessionVariables = {
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    LIBVA_DRIVER_NAME = "nvidia";
    NIXOS_OZONE_WL = "1";
    __GL_GSYNC_ALLOWED = "1";
    __GL_VRR_ALLOWED = "1";
  };

  # 7. Add CUDA & Monitoring Tools to system packages
  environment.systemPackages = with pkgs; [
    koboldcpp
    cudaPackages.cudatoolkit
    clinfo
    nvtopPackages.nvidia
  ];
}