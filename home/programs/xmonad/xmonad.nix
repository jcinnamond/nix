{ pkgs, config, ... }:

let
  configHome = config.xdg.configHome;
in
{
  home.packages = with pkgs; [
    setroot
    playerctl
    pulseaudio
    pasystray
    nautilus
  ];

  xsession = {
    enable = true;

    initExtra = ''
      ${pkgs.blueman}/bin/blueman-applet &
      ${pkgs.pasystray}/bin/pasystray &
      ${pkgs.setroot}/bin/setroot -fw "${configHome}/backgrounds/background.png"
    '';

    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = hp: [
        hp.dbus
        hp.monad-logger
      ];
      config = ./config/Main.hs;
    };
  };

  xdg.configFile."backgrounds/background.png".source = ./background.png;

  services.picom = {
    enable = true;
    backend = "xrender";
  };
}
