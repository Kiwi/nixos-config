{ ... }:

## main personal Laptop
# Lenovo Thinkpad T580
# CPU: i7-8550U
# iGPU: Intel UHD Graphics 620 (active)
# dGPU: NVIDIA GeForce MX150 (inactive)
# Display: 15.6" UHD (3840 x 2160)

{
  imports = [
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    # profile
    ../../profiles/thinkpad.nix
    # modules
    ../../modules/hardware/cpu/intel/default.nix
    ../../modules/services/xserver/window-managers/i3.nix
    ../../modules/programs/zsh.nix
    ../../modules/services/hardware/pcscd.nix
    ../../modules/virtualisation/libvirtd/default.nix
    # overlays
    ../../overlays/HiDPI.nix
    ../../overlays/no-nvidia.nix
    ../../overlays/intel-vaapi.nix
    ../../overlays/xorg-no-sleep.nix
    # fix
    ../../fix/cpu-throttling-bug.nix
    # users
    ../../users/sylv.nix
  ];

  ### INIT #####################################################################
  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];

  ### GENERAL ##################################################################
  general.name = "T580";
  general.boot.efi = "/dev/nvme0n1p1";
  general.boot.encryptData = true;
  general.boot.encryptHome = true;
  general.dpi = 192;

  system.stateVersion = "18.09";
  nix.maxJobs = 8;

  ### USER #####################################################################
  users.users.sylv.extraGroups = [
    "wheel" # privileged user
    "networkmanager" # manage network
    "video" # hardware acceleration access
    "dialout" # allow serial console access
    "libvirtd" # manage libvirt vms
    "docker" # allow direct docker api access (Warning: The docker group grants
    # privileges equivalent to the root user.
    # [https://docs.docker.com/engine/security/security/#docker-daemon-attack-surface)
  ];

  ### SERVICES #################################################################
  services = {
    # custom configuration
    compton = {
      refreshRate = 60;
      extraOptions =
''
glx-no-stencil = true;
glx-no-rebind-pixmap = true;
glx-swap-method = "buffer-age";
'';
    };
  };

  ### POWER MANAGEMENT #########################################################
  services.tlp.extraConfig = ''
    START_CHARGE_THRESH_BAT0=60
    STOP_CHARGE_THRESH_BAT0=80
    START_CHARGE_THRESH_BAT1=60
    STOP_CHARGE_THRESH_BAT1=80
  '';
  ### VIRTUALISATION ###########################################################
  virtualisation.docker.enable = true;
}
