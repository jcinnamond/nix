{ ... }:
{
  imports = [
    ./hardware-configuration.nix

    ../../modules/audio
    ../../modules/bluetooth
    ../../modules/default-packages
    ../../modules/gnome
    ../../modules/locale
    ../../modules/mounts
    ../../modules/nix
    ../../modules/printing
    ../../modules/scanning
    ../../modules/systemd-boot
    ../../modules/virtualisation

    ../../users
  ];

  hardware.sensor.iio.enable = true;

  home-manager.extraSpecialArgs = {
    extraImports = [ ];
  };

}
