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
        background = "#00000000";
        bg = bg;
        foreground = fg;
        dateForeground = fg;
        dimmed = fg2;
        alert = alert;
        active = selection;
      };
      "fonts" = with fonts; {
        font-0 = "${nerdfont}";
        font-1 = "${variableWidth}:size=13;2";
        font-2 = "${nerdfont}:size=13;2";
      };
    };
    extraConfig =
      with pkgs;
      with colors;
      ''
        [module/now-playing]
        type = custom/script
        format = <label>
        exec = ${nowPlayingLocation}
        interval = 1
        label-font = 2

        [module/date]
        type = custom/script
        exec = ${coreutils}/bin/date +" %a %d %h %-I:%M %P "
        interval = 60
        label-foreground = ${fg0}
        label-background = ${bg0}
        label-font = 2
        format-font = 3
        format-prefix = ""
        format-prefix-foreground = ${bg0}
        format-suffix = ""
        format-suffix-foreground = ${bg0}
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
