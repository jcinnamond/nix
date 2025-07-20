{ config, ... }:
let
  fonts = config.style.fonts;
in
{
  programs.ghostty = {
    enable = true;
    installBatSyntax = true;
    settings = {
      theme = "AtomOneLight";
      font-family = "${fonts.monospaced}";
      font-size = 36;
      window-decoration = "none";
    };
  };
}
