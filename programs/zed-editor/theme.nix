{ config, ... }:
let
  colors = config.style.colors;
in
{
  programs.zed-editor.themes = with colors.withHash; {
    jc = {
      "$schema" = "https://zed.dev/schema/themes/v0.2.0.json";
      name = "jc darkness";
      author = "John";
      themes = [
        {
          name = "jc dark";
          appearance = "dark";
          style = {
            background = "${bg}";
            "editor.background" = "${bg}";
            "editor.gutter.background" = "${bg}";
            "editor.active_line.background" = "${bg0}";
            "status_bar.background" = "${bg-darker}";

            foreground = "${fg}";
            text = "${fg}";

            "editor.line_number" = "${fg1}";
            "editor.active_line_number" = "${fg}";
            "editor.wrap_guide" = "${bg1}";

            error = "${alert}"; # a comment

            players = [
              {
                cursor = "${fg}";
                selection = "${selection}";
              }
            ];

            syntax = {
              comment = {
                color = "${comments}";
                font_style = "italic";
                font_weight = null;
              };
              string = {
                color = "${strings}";
                font_style = null;
                font_weight = null;
              };
            };
          };
        }
      ];
    };
  };
}
