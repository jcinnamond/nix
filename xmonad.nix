{ pkgs, ... }:

{
  programs.dconf.enable = true;

  services = {
    gnome.gnome-keyring.enable = true;
    upower.enable = true;
    
    dbus = {
      enable = true;
      packages = [ pkgs.dconf ];
    };

    libinput = {
      enable = true;
    };

    xserver = {
    	enable = true;
      windowManager.xmonad = {
        enable = true;
      };
    };

    displayManager.defaultSession = "none+xmonad";
  };

  systemd.services.upower.enable = true;
}
