{ pkgs, config, ... }:
let
  extra-vscode-extensions = {
    gregoire.dance = pkgs.vscode-utils.extensionFromVscodeMarketplace {
      publisher = "gregoire";
      name = "dance";
      version = "0.5.15001";
      sha256 = "sha256-gGTpeOQeIQj2ObyC6504+lzLFUS35RNw5z2/isPRpyM=";
    };
  };

  fonts = config.style.fonts;
in
{
  config.programs.vscode = {
    enable = true;
    profiles.default.extensions =
      with pkgs.vscode-extensions;
      with extra-vscode-extensions;
      [
        gregoire.dance
        usernamehw.errorlens
        haskell.haskell
        kahole.magit
        jnoortheen.nix-ide
      ];
  };

  config.xdg.configFile."Code/User/settings-nix.json".text = with fonts; ''
    {
      "editor.fontFamily": "'${monospaced}'",
      "editor.fontSize": 15,
      "editor.fontLigatures": true,
      "terminal.integrated.fontSize": 15,

      "editor.minimap.enabled": false,
      "workbench.activityBar.location": "hidden",
      "workbench.sideBar.location": "right",
      "workbench.layoutControl.enabled": false,
      "chat.commandCenter.enabled": false,

      "editor.formatOnSave": true,

      "nix.enableLanguageServer": true,
      "nix.serverSettings": {
          "nil": {
              "formatting": {
                  "command": ["nixfmt"]
              }
          }
      }
    }
  '';
}
