{ pkgs, config, ... }:

let
  colors = config.lib.stylix.colors.withHashtag;
in
{
  home.packages = with pkgs; [
    pulseaudio
    pasystray
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
        "Colors.hs" = pkgs.writeText "Colors.hs" ''
          module Colors where
          focusedColor :: String
          focusedColor = "${colors.base0D}"
          inactiveColor :: String
          inactiveColor = "${colors.base03}"
        '';
      };
    };
  };

  services.picom = {
    enable = true;
    backend = "xrender";
  };
}
