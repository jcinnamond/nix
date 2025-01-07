{ lib, config, ... }:
with lib;
{
  options.style = {
    font = mkOption {
      type = types.nonEmptyStr;
      description = "standard monospaced font";
    };
    fontWithSize = mkOption {
      type = types.nonEmptyStr;
      description = "standard font, including size";
    };
    fontsize = mkOption {
      type = types.int;
      description = "standard font size";
      default = 12;
    };
    nerdfont = mkOption {
      type = types.nonEmptyStr;
      description = "font with nerdfont patches";
    };
    nerdfontWithSize = mkOption {
      type = types.nonEmptyStr;
      description = "font with nerdfont patches, including size";
    };
    variableWidthFont = mkOption {
      type = types.nonEmptyStr;
      description = "standard font";
    };
    baseColors = mkOption {
      type = types.attrs;
      description = "underlying color scheme. Try to us 'colors' instead for application styling";
    };
    baseColorsWithoutHash = mkOption {
      type = types.attrs;
      description = "base colors with the leading # removed";
    };
    colors = mkOption {
      type = types.attrs;
      description = "colors to use when styling applications";
    };
  };

  config.style = {
    font = "MonolisaJc";
    fontWithSize = "${config.style.font} ${toString config.style.fontsize}";
    nerdfont = "MonolisaJc Nerd Font";
    nerdfontWithSize = "${config.style.nerdfont} ${toString config.style.fontsize}";
    variableWidthFont = "DejaVu Sans";
    baseColors = {
      transparent = "#000000";

      # Everforest dark hard color scheme
      # https://github.com/sainnhe/everforest?tab=readme-ov-file
      bg_dim = "#1e2326";
      bg0 = "#272e33";
      bg1 = "#2e383c";
      bg2 = "#374145";
      bg3 = "#414b50";
      bg4 = "#495156";
      bg5 = "#4f5b58";
      bg_red = "#4c3743";
      bg_visual = "#493b40";
      bg_yellow = "#45443c";
      bg_green = "#3c4841";
      bg_blue = "#384b55";
      red = "#e67e80";
      orange = "#e69875";
      yellow = "#dbbc7f";
      green = "#a7c080";
      blue = "#7fbbb3";
      aqua = "#83c092";
      purple = "#d699b6";
      fg = "#d3c6aa";
      statusline1 = "#a7c080";
      statusline2 = "d3c6aa";
      statusline3 = "#e67e80";
      gray0 = "#7a8478";
      gray1 = "#859289";
      gray2 = "#9da9a0";
    };
    baseColorsWithoutHash = builtins.mapAttrs (_: lib.strings.removePrefix "#") config.style.baseColors;
    colors = with config.style.baseColors; {
      alert = red;
      transparent = transparent;
      background = bg0;
      backgroundDim = bg_dim;
      text = fg;
      textDim = gray1;
      textDimmest = bg3;
      focusedBorder = bg_visual;
      unfocusedBorder = bg_dim;
      selectionBackground = bg_blue;
      selectionForeground = fg;
    };
  };
}
