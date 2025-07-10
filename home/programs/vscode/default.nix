{ pkgs, config, ... }:
let
  fonts = config.style.fonts;
  colors = config.style.colors.withHash;
  translucent = config.style.colors.translucentWithHash;
in
{
  config.programs.vscode = {
    enable = true;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        haskell.haskell
        kahole.magit
        jnoortheen.nix-ide
        golang.go
      ];
      keybindings = [
        {
          key = "ctrl+'";
          command = "editor.action.smartSelect.expand";
          when = "editorTextFocus";
        }
        {
          key = "ctrl+alt+meta+'";
          command = "editor.action.smartSelect.shrink";
          when = "editorTextFocus";
        }
        {
          key = "ctrl+shift+t";
          command = "workbench.action.createTerminalEditorSide";
        }
        {
          key = "ctrl+b";
          command = "workbench.action.togglePanel";
        }
        {
          key = "ctrl+j";
          command = "workbench.action.toggleSidebarVisibility";
        }
        {
          key = "ctrl+alt+c";
          command = "workbench.action.toggleCenteredLayout";
        }
      ];
      userSettings =
        with fonts;
        with colors;
        {
          # Privacy settings
          "telemetry.telemetryLevel" = "off";
          "telemetry.feedback.enabled" = false;
          "workbench.enableExperiments" = false;
          "extensions.autoUpdate" = false;
          "extensions.autoCheckUpdates" = false;
          "extensions.ignoreRecommendations" = true;

          # Disable chat assistants
          "terminal.integrated.initialHint" = false;
          "chat.agent.enabled" = false;
          "chat.commandCenter.enabled" = false;

          "editor.fontFamily" = "'${nerdfont}'";
          "editor.fontSize" = 15;
          "editor.fontLigatures" = true;
          "terminal.integrated.fontSize" = 15;

          "editor.minimap.enabled" = false;
          "workbench.activityBar.location" = "hidden";
          "workbench.sideBar.location" = "right";
          "workbench.layoutControl.enabled" = false;
          "workbench.panel.defaultLocation" = "right";
          "editor.stickyScroll.enabled" = false;
          "window.commandCenter" = false;
          "window.menuBarVisibility" = "hidden";
          "window.customTitleBarVisibility" = "never";
          "window.titleBarStyle" = "custom"; # making this "native" seems to force the menu bar to be visible

          "breadcrumbs.icons" = false;
          "breadcrumbs.symbolPath" = "off";
          "workbench.editor.showTabs" = "single";

          "editor.suggest.preview" = true;
          "editor.hover.enabled" = false;
          "editor.suggestOnTriggerCharacters" = false;
          "editor.parameterHints.enabled" = false;
          "editor.quickSuggestions" = {
            "other" = "off";
            "comments" = "off";
            "strings" = "off";
          };
          "editor.tabCompletion" = "onlySnippets";

          "editor.formatOnSave" = true;

          "nix.enableLanguageServer" = true;
          "nix.serverSettings" = {
            "nil" = {
              "formatting" = {
                "command" = [ "nixfmt" ];
              };
            };
          };

          "go.lintTool" = "golangci-lint";
          "gopls" = {
            "ui.semanticTokens" = true;
          };

          "haskell.manageHLS" = "PATH";
          "haskell.cabalFormattingProvider" = "cabal-gild";
          "haskell.formattingProvider" = "fourmolu";
          "haskell.plugin.semanticTokens.globalOn" = true;

          "editor.bracketPairColorization.enabled" = false;
          "workbench.colorCustomizations" = {
            "editor.background" = "${bg}";
            "editor.foreground" = "${fg}";
            "editor.selectionForeground" = "${fg}";
            "editor.selectionBackground" = "${selection}";
            "editor.lineHighlightBackground" = "${bg0}";

            "sidebar.background" = "${bg0}";
            "sidebar.foreground" = "${fg}";

            "editorLineNumber.foreground" = "${fg1}";
            "editorLineNumber.background" = "${bg2}";
            "editorLineNumber.activeForeground" = "${fg}";
            "editorLineNumber.dimmedForeground" = "${fg2}";

            "editor.wordHighlightBackground" = "${translucent.bg1}";
            "editor.wordHighlightStrongBackground" = "${translucent.bg1}";
            "editor.wordHighlightStrongBorder" = "${yellow-dark}";
            "editor.wordHighlightTextBackground" = "${translucent.bg}";
          };

          "editor.tokenColorCustomizations" = {
            "textMateRules" = [
              {
                "name" = "keywords";
                "scope" = [
                  "keyword"
                  "keyword.control"
                ];
                "settings" = {
                  "fontStyle" = "";
                  "foreground" = "${keywords}";
                };
              }
              {
                "name" = "literals";
                "scope" = [
                  "string"
                  "string.regexp"
                  "constant.character.escape"
                  "constant.numeric"
                  "constant.language"
                ];
                "settings" = {
                  "fontStyle" = "";
                  "foreground" = "${strings}";
                };
              }
              {
                "name" = "string placeholders";
                "scope" = [ "constant.other.placeholder" ];
                "settings" = {
                  "foreground" = "${keywords}";
                };
              }
              {
                "name" = "comment";
                "scope" = [ "comment" ];
                "settings" = {
                  "fontStyle" = "";
                  "foreground" = "${comments}";
                };
              }
              {
                "name" = "punctuation";
                "scope" = [
                  "punctuation"
                  "punctuation.section.embedded"
                  "keyword.operator"
                  "delimiter"
                  "bracket"
                  "brace"
                  "paren"
                ];
                "settings" = {
                  "fontStyle" = "";
                  "foreground" = "${keywords}";
                };
              }
              {
                "name" = "catchall";
                "scope" = [
                  "constant.other.option"
                  "variable"
                  "variable.language"
                  "variable.parameter"
                  "variable.other.readwrite"
                  "variable.other.constant"
                  "entity.name.type"
                  "entity.name.function"
                  "entity.name.namespace"
                  "entity.other.attribute"
                  "entity.name.import.go"
                  "support.type"
                  "support.type.property-name"
                  "support.class"
                  "support.function"
                  "support.variable"
                  "storage.type.numeric.go"
                  "storage.type.string.go"
                  "storage.type.boolean.go"
                ];
                "settings" = {
                  "fontStyle" = "";
                  "foreground" = "${fg}";
                };
              }
            ];
          };
        };
    };
  };
}
