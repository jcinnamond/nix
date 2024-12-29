{ pkgs, config, ... }:

let
  colors = config.lib.stylix.colors.withHashtag;
  nowPlayingLocation = "${config.xdg.configHome}/polybar/now-playing";
in
{
  services.polybar = {
    enable = true;
    package = pkgs.polybar.override { pulseSupport = true; };
    config = ./config.ini;
    script = ''
      polybar top &
    '';
    extraConfig = ''
      [module/now-playing]
      type = custom/script
      format = <label>
      exec = ${nowPlayingLocation}
      interval = 1
    '';
  };
  home.file."${nowPlayingLocation}" = {
    text = ''
      #!/bin/sh

      playerctl="${pkgs.playerctl}/bin/playerctl"
      playerctlstatus=$($playerctl status)
      cut="${pkgs.coreutils}/bin/cut"

      if [[ $playerctlstatus == "" ]]; then
        echo ""
        exit 0
      fi

      if [[ $playerctlstatus == "Playing" ]]; then
        echo -n "%{F${colors.base0D}}▶ "
      else 
        echo -n "%{F${colors.base03}} "
      fi

      $playerctl metadata --format "{{artist}}: {{title}}" | $cut -c-80
    '';
    executable = true;
  };
}
