{ pkgs, config, ... }:

let
  inherit (config.lib.formats.rasi) mkLiteral;
  colors = config.style.colors.withHash;
  fonts = config.style.fonts;

  default-padding = mkLiteral "12px";
  small-padding = mkLiteral "8px";
  default-spacing = mkLiteral "8px";
  default-margin = mkLiteral "12px";
  default-right-margin = mkLiteral "0 12px 0 0";
  default-border-radius = mkLiteral "16px";
in
{
  config.programs.rofi = {
    enable = true;
    terminal = "${pkgs.kitty}/bin/kitty";
    plugins = with pkgs; [
      rofi-calc
    ];
    font = fonts.withSize fonts.nerdfont;
    extraConfig = {
      modi = "drun,run,window,calc";
      display-drun = " Apps";
      display-run = " Run";
      display-window = " Windows";
      display-calc = " Calc";
      drun-display-format = "{name}";
      run-shell-command = "${pkgs.kitty}/bin/kitty --hold {cmd}";
    };
    theme = with colors; {
      "*" = {
        background-color = mkLiteral bg;
        text-color = mkLiteral fg;
      };

      window = {
        width = mkLiteral "800px";
        border-radius = default-border-radius;
        padding = default-padding;
        border-color = mkLiteral bg2;
        border = mkLiteral "2px";
      };

      scrollbar = {
        background-color = mkLiteral bg0;
        handle-color = mkLiteral bg2;
        handle-width = mkLiteral "12px";
        border-radius = mkLiteral "8px";
      };

      mainbox = {
        padding = default-padding;
        children = [
          "inputbar"
          "message"
          "listview"
          "mode-switcher"
        ];
      };

      inputbar = {
        padding = default-padding;
        spacing = default-spacing;
        children = [
          "prompt"
          "entry"
          "case-indicator"
        ];
      };

      entry = {
        placeholder = "...";
        placeholder-color = mkLiteral fg2;
      };

      message = {
        margin = default-margin;
        border-radius = default-border-radius;
        background-color = mkLiteral bg1;
      };

      textbox = {
        padding = default-padding;
        background-color = mkLiteral bg1;
      };

      listview = {
        margin = default-margin;
        lines = 6;
        columns = 2;

        fixed-height = false;
        dynamic = false;
        scrollbar = true;
      };

      element = {
        padding = small-padding;
        margin = default-right-margin;
        spacing = default-spacing;
        border-radius = default-border-radius;
      };

      "element-text, element-icon" = {
        background-color = mkLiteral "transparent";
      };

      "element-text selected" = {
        text-color = mkLiteral fg;
      };

      "element selected normal, element selected active" = {
        background-color = mkLiteral selection;
        text-color = mkLiteral fg;
      };

      element-icon = {
        size = mkLiteral "1em";
        vertical-align = mkLiteral "0.5";
      };

      mode-switcher = {
        orientation = "horizontal";
        enabled = true;
        spacing = default-spacing;
      };

      button = {
        padding = small-padding;
        border-radius = default-border-radius;
      };

      "button selected" = {
        background-color = mkLiteral bg1;
      };
    };
  };
}
