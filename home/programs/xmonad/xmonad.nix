{ pkgs, ... }:

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
    };
  };

  services.picom = {
    enable = true;
    backend = "xrender";
  };
}
