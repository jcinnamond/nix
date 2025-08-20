{ pkgs, config, ... }:

let
  colors = config.style.colors.withHash;
in
{
  home.packages = with pkgs; [
    feh
    libnotify
    nautilus
    pasystray
    ponymix
    pulseaudio
  ];

  imports = [
    ../../programs/rofi
    ../../services/polybar
    ../../services/wired
    ../../services/flameshot
  ];

  home.file."wallpaper.png".source = ../../modules/style/wallpapers/milky-way.png;

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };

  xsession = {
    enable = true;

    initExtra = ''
      ${pkgs.blueman}/bin/blueman-applet &
      ${pkgs.pasystray}/bin/pasystray &
      ${pkgs.feh}/bin/feh --no-fehbg --bg-scale ~/wallpaper.png
    '';

    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = hp: [
        hp.dbus
        hp.monad-logger
      ];
      config = ./config/Main.hs;
      libFiles = {
        "Nix.hs" = pkgs.writeText "Nix.hs" ''
          module Nix where
          ponymix :: String
          ponymix = "${pkgs.ponymix}/bin/ponymix"
          notify :: String
          notify = "${pkgs.libnotify}/bin/notify-send"
          focusedBorderColor :: String
          focusedBorderColor = "${colors.activeBorder}"
          normalBorderColor :: String
          normalBorderColor = "${colors.inactiveBorder}"
        '';
        "Volume.hs" = ./config/Volume.hs;
      };
    };
  };

  services.picom = {
    enable = true;
    backend = "xrender";
  };
}
