{ pkgs, config, ... }:
let
  fonts = config.style.fonts;
  colors = config.style.colors.withHash;
in
{
  config.programs.vscode = {
    enable = true;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        usernamehw.errorlens
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
      ];
      userSettings =
        with fonts;
        with colors;
        {
          "editor.fontFamily" = "'${nerdfont}'";
          "editor.fontSize" = 15;
          "editor.fontLigatures" = true;
          "terminal.integrated.fontSize" = 15;

          "editor.minimap.enabled" = false;
          "workbench.activityBar.location" = "hidden";
          "workbench.sideBar.location" = "right";
          "workbench.panel.defaultLocation" = "left";
          "workbench.layoutControl.enabled" = false;
          "chat.commandCenter.enabled" = false;

          "editor.formatOnSave" = true;

          "extensions.autoCheckUpdates" = false;

          "nix.enableLanguageServer" = true;
          "nix.serverSettings" = {
            "nil" = {
              "formatting" = {
                "command" = [ "nixfmt" ];
              };
            };
          };

          "haskell.cabalFormattingProvider" = "cabal-fmt";
          "haskell.formattingProvider" = "fourmolu";

          "editor.bracketPairColorization.enabled" = false;
          "workbench.colorCustomizations" = {
            "sideBar.background" = "${bg0}";
            "editor.background" = "${bg}";
            "editor.foreground" = "${fg}";
            "editor.selectionBackground" = "${selection}";
            "editorGutter.background" = "${bg0}";
            "editorLineNumber.foreground" = "${fg1}";
            "editorLineNumber.activeForeground" = "${fg}";
            "editorCursor.foreground" = "${fg}";
            "editor.lineHighlightBackground" = "${bg0}";
            "statusBar.background" = "${bg1}";
            "statusBar.foreground" = "${fg0}";
          };

          "editor.tokenColorCustomizations" = {
            "textMateRules" = [
              {
                "scope" = [
                  "keyword"
                  "constant"
                ];
                "settings" = {
                  "foreground" = "${fg0}";
                };
              }
              {
                "scope" = [
                  "string"
                  "constant"
                  "constant.language"
                ];
                "settings" = {
                  "foreground" = "${fg1}";
                };
              }
              {
                "scope" = [
                  "support.type.property-name"
                ];
                "settings" = {
                  "foreground" = "${fg}";
                };
              }
            ];
          };
        };
    };
  };
}
