{ pkgs, ... }:
{
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "jc";
      editor.cursorline = true;
      editor.soft-wrap = {
        enable = true;
      };
      editor.cursor-shape = {
        normal = "block";
        insert = "bar";
        select = "underline";
      };
      editor.indent-guides = {
        render = true;
        character = "┊";
        skip-levels = 1;
      };
    };
    languages.language = [
      {
        name = "haskell";
        auto-format = true;
        formatter.command = "fourmolu";
        formatter.args = [
          "--stdin-input-file"
          "."
        ];
      }
      {
        name = "cabal";
        auto-format = true;
        formatter.command = "cabal-fmt";
      }
      {
        name = "nix";
        auto-format = true;
        formatter.command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
      }
    ];

    themes = {
      jc =
        let
          black = "#000000";
          bg0 = "#121212";
          bg1 = "#222222";
          bg3 = "#444444";
          bg4 = "#888888";

          white = "#f8f7f2";
          brightwhite = "#ffffff";
          fg0 = "#c7c7c7";
          fg1 = "#777777";
          fg2 = "#999999";
          fg3 = "#c1c1c1";

          red = "#79241f";
          brightred = "#a9241f";
          green = "#5f8787";
          yellow = "#fbcb97";
          blue = "#5f81a5";
          darkblue = "#1f4165";
          lightblue = "#d0dfee";
        in
        {

          "ui.background" = {
            bg = black;
          };
          "ui.text" = fg0;
          "ui.selection" = {
            bg = darkblue;
          };
          "ui.gutter" = {
            bg = bg0;
          };
          "ui.gutter.selected" = {
            bg = bg1;
          };
          "ui.linenr" = {
            fg = fg0;
          };
          "ui.linenr.selected" = {
            fg = white;
          };
          "ui.window" = fg3;

          "ui.cursor" = {
            bg = bg3;
            fg = white;
          };
          "ui.cursor.insert" = {
            bg = white;
            fg = white;
          };
          "ui.cursor.normal" = {
            bg = bg4;
          };
          "ui.cursor.match" = {
            bg = bg1;
          };
          "ui.cursor.select" = {
            bg = blue;
          };
          "ui.cursorline.primary" = {
            bg = bg0;
          };
          "ui.cursorline.secondary" = {
            bg = bg0;
          };

          "ui.statusline" = {
            bg = bg3;
            fg = white;
          };
          "ui.statusline.inactive" = {
            bg = bg0;
            fg = fg2;
          };

          "ui.popup" = {
            bg = bg1;
            fg = white;
          };
          "ui.menu" = {
            bg = bg1;
            fg = white;
          };
          "ui.menu.selected" = {
            bg = bg3;
            fg = lightblue;
          };
          "ui.highlight" = {
            bg = red;
          };
          "ui.virtual.indent-guide" = bg3;

          "warning" = {
            fg = yellow;
          };
          "error" = {
            fg = brightred;
          };
          "info" = {
            fg = blue;
          };
          "hint" = {
            fg = lightblue;
          };
          "diagnostic" = {
            underline = {
              style = "curl";
            };
          };
          "diagnostic.hint" = {
            underline = {
              color = lightblue;
              style = "dotted";
            };
          };
          "diagnostic.info" = {
            underline = {
              color = blue;
              style = "dotted";
            };
          };
          "diagnostic.warning" = {
            underline = {
              color = yellow;
              style = "dotted";
            };
          };
          "diagnostic.error" = {
            underline = {
              color = red;
              style = "dotted";
            };
            fg = brightred;
          };

          "string" = {
            fg = fg2;
            modifiers = [ "italic" ];
          };
          "keyword" = {
            fg = white;
            modifiers = [ "bold" ];
          };
          "comment" = {
            fg = fg1;
            modifiers = [ "" ];
          };
          "punctuation" = {
            fg = fg2;
          };
          "operator" = {
            fg = white;
          };
          "type" = {
            fg = white;
          };
          "markdown.heading" = {
            fg = blue;
            modifiers = [ "bold" ];
          };
          "markdown.heading.marker" = {
            fg = fg1;
          };
          "markdown.heading.1" = {
            fg = blue;
            modifiers = [ "bold" ];
          };
          "markup.heading.2" = {
            fg = yellow;
          };
          "markup.heading.3" = {
            fg = white;
          };
          "markup.heading.4" = {
            fg = white;
          };
          "diff.plus" = {
            fg = green;
          };
          "diff.minus" = {
            fg = red;
          };
          "diff.delta" = {
            fg = yellow;
          };
        };
    };
  };
}
