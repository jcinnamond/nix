{ pkgs, config, ... }:

let
  colors = config.style.colors;
in
{
  home.packages = with pkgs; [
    libnotify
    pasystray
    ponymix
    pulseaudio
    nautilus
  ];

  xsession = {
    enable = true;

    initExtra = ''
      ${pkgs.blueman}/bin/blueman-applet &
      ${pkgs.pasystray}/bin/pasystray &
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
          focusedColor :: String
          focusedColor = "${colors.focusedBorder}"
          unfocusedColor :: String
          unfocusedColor = "${colors.unfocusedBorder}"
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
