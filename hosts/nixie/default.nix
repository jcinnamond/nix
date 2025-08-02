{ pkgs, ... }:
{
  system.stateVersion = "24.05";

  networking.hostName = "nixie";

  imports = [
    ./hardware-configuration.nix
    ./boot.nix
    ./nvidia.nix
    ../../modules/locale
    ../../modules/xserver
    ../../users
  ];

  services.printing.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  virtualisation.docker.enable = true;

  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.sane-airscan ];
  };
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;

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

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  environment.systemPackages = with pkgs; [
    helix
    git
    os-prober
    pciutils
    usbutils
    base16-schemes
  ];
}
