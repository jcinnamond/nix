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
            background = "${bg-darker}";
            "editor.background" = "${bg-darker}";
            "editor.gutter.background" = "${bg}";
            "editor.active_line.background" = "${bg0}";
            "status_bar.background" = "${bg-darker}";

            foreground = "${fg}";
            text = "${fg}";

            "editor.line_number" = "${fg1}";
            "editor.active_line_number" = "${fg}";
            "editor.wrap_guide" = "${bg1}";

            "editor.document_highlight.read_background" = "${bg1}";
            "editor.document_highlight.write_background" = "${selection}";

            error = "${red-light}";
            warning = "${yellow}";
            "warning.background" = "${bg1}";
            hint = "${fg1}";

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
              keyword = {
                color = "${keywords}";
              };
            };
          };
        }
      ];
    };
  };
}
