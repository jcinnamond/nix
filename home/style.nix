{ lib, config, ... }:
with lib;
{
  options.style = {
    font = mkOption {
      type = types.nonEmptyStr;
      description = "standard font";
    };
    fontWithSize = mkOption {
      type = types.nonEmptyStr;
      description = "standard font, including size";
    };
    fontsize = mkOption {
      type = types.int;
      description = "standard font size";
      default = 12;
    };
    nerdfont = mkOption {
      type = types.nonEmptyStr;
      description = "font with nerdfont patches";
    };
    nerdfontWithSize = mkOption {
      type = types.nonEmptyStr;
      description = "font with nerdfont patches, including size";
    };
    colors = mkOption {
      type = types.attrs;
      description = "colors to use when styling applications";
    };
  };

  config.style = {
    font = "MonolisaJc";
    fontWithSize = "${config.style.font} ${toString config.style.fontsize}";
    nerdfont = "MonolisaJc Nerd Font";
    nerdfontWithSize = "${config.style.nerdfont} ${toString config.style.fontsize}";
    colors = {
      bg = "#000000";
      bg-alt = "#333333";
      fg = "#e0e0e0";
      fg-dim = "#aaaaaa";
      fg-dimmer = "#999999";
      selection-bg = "#4f709c";
      selection-fg = "#f7f7f7";
      alert = "#A23E48";
    };
  };
}
