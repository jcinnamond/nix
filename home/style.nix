{ lib, config, ... }:
with lib;
{
  options.style = {
    font = mkOption {
      type = types.nonEmptyStr;
      description = "standard font";
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
    colors = mkOption {
      type = types.attrs;
      description = "colors to use when styling applications";
    };
  };

  config.style = {
    font = "MonolisaJc ${toString config.style.fontsize}";
    nerdfont = "MonolisaJc Nerd Font ${toString config.style.fontsize}";
    colors = {
      bg = "#000000";
      bg-alt = "#333333";
      fg = "#f7f7f7";
      fg-dim = "#aaaaaa";
      selection-bg = "#4f709c";
      selection-fg = "#f7f7f7";
    };
  };
}
