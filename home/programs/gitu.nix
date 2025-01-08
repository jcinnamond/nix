{ config, pkgs, ... }:
let
  colors = config.style.colors.withHash;
in
{
  config.home.packages = with pkgs; [
    gitu
  ];

  config.xdg.configFile."gitu/config.toml".text = with colors; ''
    [style]
    section_header = { fg="${fg}", mods="BOLD" }
    file_header = { fg="${fg1}" }
    hunk_header = { fg="${fg1}" }
    hash = { fg="${fg1}" }
    selection_area = { bg="${bg0}" }
    command = { fg="${fg}" }
    hotkey = { fg="${yellow}", mods="BOLD" }
  '';
}
