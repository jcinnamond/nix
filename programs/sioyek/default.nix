{ config, ... }:
let
  fonts = config.style.fonts;
in
{
  programs.sioyek = {
    enable = true;
    config = {
      ui_font = fonts.variableWidth;
      font_size = "16";
      ruler_mode = "1";
      startup_commands = [
        "toggle_dark_mode"
      ];
    };
  };
}
