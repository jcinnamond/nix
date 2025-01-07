{ config, lib, ... }:
with lib;
{
  options.style.fonts = {
    default = mkOption {
      type = types.nonEmptyStr;
      description = "standard monospaced font";
      default = "MonolisaJc";
    };
    size = mkOption {
      type = types.int;
      description = "standard font size";
      default = 12;
    };
    nerdfont = mkOption {
      type = types.nonEmptyStr;
      description = "monospaced font with nerdfont patches";
      default = "${config.style.fonts.default} Nerd Font";
    };
    variableWidth = mkOption {
      type = types.nonEmptyStr;
      description = "standard font";
      default = "DejaVu Sans";
    };

    withSize = mkOption {
      readOnly = true;
      default = with config.style.fonts; (font: "${font} ${builtins.toString size}");
    };
  };
}
