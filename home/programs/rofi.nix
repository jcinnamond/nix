{ pkgs, config, ... }:

let
  inherit (config.lib.formats.rasi) mkLiteral;
  colors = config.style.colors;

  bg = mkLiteral colors.bg;
  bg-alt = mkLiteral colors.bg-alt;
  fg = mkLiteral colors.fg;
  fg-dim = mkLiteral colors.fg-dim;
  selection-bg = mkLiteral colors.selection-bg;
  selection-fg = mkLiteral colors.selection-fg;

  default-padding = mkLiteral "12px";
  small-padding = mkLiteral "8px";
  default-spacing = mkLiteral "8px";
  default-margin = mkLiteral "12px";
  default-right-margin = mkLiteral "0 12px 0 0";
  default-border-radius = mkLiteral "16px";
in
{
  config.stylix.targets.rofi.enable = false;
  config.programs.rofi = {
    enable = true;
    terminal = "${pkgs.kitty}/bin/kitty";
    plugins = with pkgs; [
      rofi-calc
    ];
    font = config.style.font;
    extraConfig = {
      modi = "drun,run,window";
      display-drun = " Apps";
      display-run = " Run";
      display-window = " Windows";
      display-calc = " Calc";
      drun-display-format = "{name}";
      run-shell-command = "${pkgs.kitty}/bin/kitty --hold {cmd}";
    };
    theme = {
      "*" = {
        background-color = bg;
        text-color = fg;
      };

      window = {
        width = mkLiteral "800px";
        border-radius = default-border-radius;
        padding = default-padding;
        border-color = bg-alt;
        border = mkLiteral "2px";
      };

      scrollbar = {
        background-color = bg-alt;
        handle-color = selection-bg;
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
        placeholder-color = fg-dim;
      };

      message = {
        margin = default-margin;
        border-radius = default-border-radius;
        background-color = bg-alt;
      };

      textbox = {
        padding = default-padding;
        background-color = bg-alt;
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
        text-color = selection-fg;
      };

      "element selected normal, element selected active" = {
        background-color = selection-bg;
        text-color = selection-fg;
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
        background-color = selection-bg;
      };
    };
  };
}
