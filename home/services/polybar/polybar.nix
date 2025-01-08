{ pkgs, config, ... }:

let
  colors = config.style.colors.withHash;
  fonts = config.style.fonts;
  nowPlayingLocation = "${config.xdg.configHome}/polybar/now-playing";
in
{
  services.polybar = {
    enable = true;
    package = pkgs.polybar.override { pulseSupport = true; };
    config = ./config.ini;
    script = ''
      polybar top &
      polybar bottom &
    '';
    settings = with colors; {
      "colors" = {
        background = "#ff000000";
        foreground = fg;
        dimmed = fg2;
        alert = alert;
        active = selection;
      };
      "fonts" = with fonts; {
        default = nerdfont;
      };
    };
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
      head="${pkgs.coreutils}/bin/head"
      cut="${pkgs.coreutils}/bin/cut"

      mediasource() {
        local source=$($playerctl -l | $head -1 | $cut -d'.' -f1) 
        case $source in
          "spotify")
            echo -n "󰝚"
            ;;
          "firefox")
            echo -n ""
            ;;
          *)
            echo -n "($source)"
            ;;
        esac
      }

      playerctlstatus=$($playerctl status 2>&1)
      if [[ $? -ne 0 || -z "$playerctlstatus" || "$playerctlstatus" == "No players found" ]]; then
        echo ""
        exit 0
      fi

      if [[ $playerctlstatus == "Playing" ]]; then
        echo -n "%{F${colors.fg}}▶ $(mediasource)  "
        durationcolor="${colors.fg1}"
      else 
        echo -n "%{F${colors.fg2}} $(mediasource)  "
        durationcolor="${colors.fg2}"
      fi

      $playerctl metadata --format "{{artist}}: {{title}} %{F$durationcolor}({{duration(position)}}/{{duration(mpris:length)}})"
    '';
    executable = true;
  };
}
