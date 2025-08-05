{ pkgs, ... }:
{
  imports = [
    ../../programs/obs
    ../../programs/rofi
    ../../programs/xmonad
    ../../services/polybar
    ../../services/wired
  ];

  home.packages.streamcontroller.enable = true;

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };
}
