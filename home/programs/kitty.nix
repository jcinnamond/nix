{ lib, config, ... }:
{
  programs.kitty = {
    enable = true;
    font.name = lib.mkForce "MonoLisa jc";
    font.size = 12;
    shellIntegration.enableFishIntegration = true;
    keybindings = {
      "ctrl+tab" = "next_window";
    };
    settings = {
      enabled_layouts = "tall,stack";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
    };
    extraConfig = with config.style.colors.withHash; ''
      background  ${bg}
      foreground  ${fg}
      cursor      ${fg}

      color0  ${bg}
      color7  ${fg2}
      color8  ${fg1}
      color15 ${fg}

      color1  ${red}
      color9  ${red-light}

      color2  ${green}
      color10  ${green-light}

      color3  ${yellow}
      color11  ${yellow-light}

      color4  ${blue}
      color12 ${blue-light}

      color5 ${magenta}
      color13 ${magenta-light}

      color6 ${cyan}
      color14 ${cyan-light}

      selection_foreground ${fg}
      selection_background ${selection}
      active_border_color  ${activeBorder}
    '';
  };
}
