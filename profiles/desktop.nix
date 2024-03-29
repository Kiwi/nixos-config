{ config, lib, pkgs, ... }:

# Profile for any personal device with direct user interaction
# (e.g. Workstations, laptops, media devices).

  {
  imports = [
    ./default.nix # parent
    ./pkgs/desktop.nix

    ./modules/config.nix
    ./modules/theme.nix
    ./modules/x11.nix
  ];

  ### HARDWARE #################################################################
  # enable sound
  sound.enable = lib.mkDefault true;
  hardware = {
    pulseaudio = {
      enable = lib.mkDefault true;
      # add the extended pkg to support bluetooth audio
      package = pkgs.pulseaudioFull;
    };
  };
  # enable bluetooth
  hardware.bluetooth.enable = lib.mkDefault true;
  # enable accelerated OpenGL rendering
  hardware.opengl.enable = lib.mkDefault true;

  ### NETWORK ##################################################################
  # use NetworkManager
  networking.networkmanager.enable = lib.mkDefault true;

  ### SERVICES #################################################################
  services = {
    # gnome services
    gnome3 = {
      evolution-data-server.enable = true;
      gnome-keyring.enable = true;
    };
    # minimize log size
    journald.extraConfig = "SystemMaxUse=500M";
    # enable avahi protocol to mdns addresses
    avahi = {
      enable = lib.mkDefault true;
      nssmdns = true;
      #ipv6 = true;
    };
    # secure firmware updates
    fwupd.enable = lib.mkDefault true;
    # ACPI event handler
    acpid.enable = true;
  };
  programs = {
    # enable gnupg ssh-agent
    gnupg.agent = {
      enable = lib.mkDefault true;
      enableSSHSupport =true;
    };
  };
}
