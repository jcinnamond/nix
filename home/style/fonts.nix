{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
{
  config.home.packages = with pkgs; [
    inter-nerdfont
    monolisa-jc
  ];

  options.style.fonts = {
    monospaced = mkOption {
      type = types.nonEmptyStr;
      description = "standard monospaced font";
      default = "MonoLisa jc";
    };
    size = mkOption {
      type = types.int;
      description = "standard font size";
      default = 12;
    };
    nerdfont = mkOption {
      type = types.nonEmptyStr;
      description = "monospaced font with nerdfont patches";
      default = "MonoLisaJc Nerd Font";
    };
    variableWidth = mkOption {
      type = types.nonEmptyStr;
      description = "standard font";
      default = "Inter Nerd Font";
    };
    heading = mkOption {
      type = types.nonEmptyStr;
      description = "heading font";
      default = "DejaVu Sans Condensed Bold";
    };

    withSize = mkOption {
      readOnly = true;
      default = with config.style.fonts; (font: "${font} ${builtins.toString size}");
    };
  };
}
