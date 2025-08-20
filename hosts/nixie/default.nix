{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./nvidia.nix

    ../../modules/audio
    ../../modules/bluetooth
    ../../modules/default-packages
    ../../modules/gnome
    ../../modules/grub
    ../../modules/locale
    ../../modules/mounts
    ../../modules/nix
    ../../modules/printing
    ../../modules/scanning
    ../../modules/virtualisation
    ../../modules/xmonad

    ../../users
  ];

  home-manager.extraSpecialArgs = {
    extraImports = [
      ../../programs/obs
      ../../programs/streamcontroller
      ../../programs/xmonad
    ];
  };
}
