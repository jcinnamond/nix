{ config, pkgs, ... }:
let
  colors = config.style.colors.withHash;
in
{
  config.programs.helix = {
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
      editor.end-of-line-diagnostics = "hint";
      editor.inline-diagnostics = {
        cursor-line = "error";
        other-lines = "error";
      };
    };
    languages = {
      language-server.fish-lsp = with pkgs; {
        command = "${fish-lsp}/bin/fish-lsp";
        args = [ "start" ];
      };
      language = [
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
        {
          name = "fish";
          language-servers = [ "fish-lsp" ];
        }
      ];
    };

    themes = {
      jc = with colors; {
        "ui.background" = {
          bg = bg;
        };
        "ui.text" = fg;
        "ui.selection" = {
          bg = selection;
        };
        "ui.gutter" = {
          bg = bg0;
        };
        "ui.gutter.selected" = {
          bg = bg1;
        };
        "ui.linenr" = {
          fg = fg1;
        };
        "ui.linenr.selected" = {
          fg = fg;
        };
        "ui.window" = fg2;

        "ui.cursor" = {
          bg = fg2;
          fg = fg;
        };
        "ui.cursor.insert" = {
          bg = fg;
          fg = fg;
        };
        "ui.cursor.normal" = {
          bg = bg2;
        };
        "ui.cursor.match" = {
          bg = bg2;
        };
        "ui.cursor.select" = {
          bg = selection;
        };
        "ui.cursorline.primary" = {
          bg = bg0;
        };
        "ui.cursorline.secondary" = {
          bg = bg0;
        };

        "ui.statusline" = {
          bg = bg1;
          fg = fg0;
        };
        "ui.statusline.inactive" = {
          bg = bg0;
          fg = fg2;
        };

        "ui.popup" = {
          bg = bg1;
          fg = fg;
        };
        "ui.menu" = {
          bg = bg0;
          fg = fg1;
        };
        "ui.menu.selected" = {
          bg = selection;
          fg = fg;
        };
        "ui.highlight" = {
          bg = red-dark;
        };
        "ui.virtual.indent-guide" = bg1;
        "ui.virtual.wrap" = bg2;
        "ui.virtual.ruler" = {
          bg = bg0;
        };

        "warning" = {
          fg = yellow;
        };
        "error" = {
          fg = red-light;
        };
        "info" = {
          fg = blue;
        };
        "hint" = {
          fg = cyan-light;
        };
        "diagnostic" = {
          underline = {
            style = "curl";
          };
        };
        "diagnostic.hint" = {
          underline = {
            color = cyan-light;
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
            color = red-dark;
            style = "dotted";
          };
          fg = red;
        };

        "string" = {
          fg = fg0;
          modifiers = [ "italic" ];
        };
        "keyword" = {
          fg = fg;
          modifiers = [ "bold" ];
        };
        "comment" = {
          fg = fg1;
          modifiers = [ "" ];
        };
        "punctuation" = {
          fg = fg1;
        };
        "operator" = {
          fg = fg;
        };
        "type" = {
          fg = fg;
        };
        "markup.heading.marker" = {
          fg = fg2;
        };
        "markup.heading.1" = {
          fg = blue;
          modifiers = [ "bold" ];
        };
        "markup.heading.2" = {
          fg = yellow;
          modifiers = [ "bold" ];
        };
        "markup.heading.3" = {
          fg = fg;
          modifiers = [ "bold" ];
        };
        "markup.heading.4" = {
          fg = fg;
          modifiers = [ "bold" ];
        };
        "markup.list.checked" = {
          fg = fg1;
        };
        "markup.raw.block" = {
          bg = bg0;
        };
        "diff.plus" = {
          fg = green-dark;
        };
        "diff.minus" = {
          fg = red-dark;
        };
        "diff.delta" = {
          fg = bg2;
        };
      };
    };
  };
}
