{ config, ... }:
let
  fonts = config.style.fonts;
in
{
  programs.sioyek = {
    enable = true;
    config = {
      ui_font = fonts.variableWidth;
      font_size = "20";
    };
  };
}
