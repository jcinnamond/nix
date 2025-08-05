{ ... }:
{
  services.udisks2.enable = true;

  fileSystems."/mnt/synology" = {
    device = "synology:/volume1/storage";
    fsType = "nfs";
    options = [
      "x-systemd.automount"
      "noauto"
      "x-systemd.idle-timeout=600"
    ];
  };
}
