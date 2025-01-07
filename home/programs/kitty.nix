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
      background  ${base00}
      foreground  ${base07}
      cursor      ${base07}

      color0  ${base00}
      color1  ${base01}
      color2  ${base02}
      color3  ${base03}
      color4  ${base04}
      color5  ${base05}
      color6  ${base06}
      color7  ${base07}
      color8  ${base08}
      color9  ${base09}
      color10 ${base0a}
      color11 ${base0b}
      color12 ${base0c}
      color13 ${base0d}
      color14 ${base0e}
      color15 ${base0f}

      selection_foreground ${base07}
      selection_background ${selection}
      active_border_color  ${activeBorder}
    '';
  };
}
