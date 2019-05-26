{ config, lib, ... }:

{
  boot = {
    initrd = {
      luks.devices = lib.mkIf config.general.boot.encryptData [
      {
        # cryptdevice with all my persistent data
        name = "data";
        device = "/dev/${config.general.name}/data";
        preLVM = false;
      }
      ];
    };
  };
  fileSystems = lib.mkIf config.general.boot.default {
    "/" = {
      device = "/dev/${config.general.name}/nixos";
      fsType = "ext4";
      options = [ "noatime" "discard" ];
   };
     "/boot/efi" = lib.mkIf config.boot.loader.grub.efiSupport {
      device = config.general.boot.efi;
      fsType = "vfat";
    };
    # partition with persistent data (user & host)

    "/data" = {
      device = if config.general.boot.encryptData then "/dev/mapper/data" else "/dev/${config.general.name}/data";
      fsType = "ext4";
      options = [ "noatime" "discard" ];
    };
  };
}