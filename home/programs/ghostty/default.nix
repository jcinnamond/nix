{ config, ... }:
let
  fonts = config.style.fonts;
in
{
  programs.ghostty = {
    enable = true;
    installBatSyntax = true;
    settings = {
      theme = "jc";
      font-family = "${fonts.monospaced}";
      font-size = 12;
      window-decoration = "none";
    };
    themes = with config.style.colors.withHash; {
      jc = {
        background = "${bg}";
        foreground = "${fg}";
        palette = [
          "0=${bg}"
          "7=${fg2}"
          "8=${fg1}"
          "15=${fg}"

          "1=${red}"
          "9=${red-light}"

          "2=${green}"
          "10=${green-light}"

          "3=${yellow}"
          "11=${yellow-light}"

          "4=${blue}"
          "12=${blue-light}"

          "5=${magenta}"
          "13=${magenta-light}"

          "6=${cyan}"
          "14=${cyan-light}"
        ];
      };
    };
  };
}
