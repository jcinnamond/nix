{ config, lib, ... }:
with lib;
{
  options.style.colors = {
    schemeName = mkOption {
      type = types.nonEmptyStr;
      description = "The name of the color scheme to load.";
      default = "plain";
    };
    scheme = mkOption {
      type = types.attrsOf types.str;
      description = "The color scheme. This overrides the 'schemeName'.";
      example = ''
        {
          # Base16 colors
          base00 = "000000"; # black
          base01 = "0000ff"; # blue
          base02 = "00ff00"; # green
          base03 = "00ffff"; # aqua
          base04 = "ff0000"; # red
          base05 = "800080"; # purple
          base06 = "ffff00"; # yellow
          base07 = "cccccc"; # white
          base08 = "999999"; # gray
          base09 = "aaaaff"; # bright blue
          base0a = "aaffaa"; # light green
          base0b = "aaffff"; # light aqua
          base0c = "ffaaaa"; # light red
          base0d = "f070f0"; # light purple
          base0e = "ffffaa"; # light yellow
          base0f = "ffffff"; # bright white

          # Common variations
          bg = "000000";
          bg0 = "222222"; # lighter background
          bg1 = "444444"; # lighter background

          fg = "cccccc";
          fg0 = "aaaaaa"; # dimmer foreground
          fg1 = "777777"; # dimmer foreground
          fg2 = "555555"; # dimmer foreground

          # Special named colors
          selection = "333377"; # selection background
          activeBorder = "800080";
          inactiveBorder = "222222";
        }
      '';
      default = import ./colors/${config.style.colors.schemeName}.nix;
    };
    withHash = mkOption {
      type = types.attrsOf types.str;
      description = "The color scheme, with the color values prefixed with '#'";
      readOnly = true;
      default = builtins.mapAttrs (_: value: "#${value}") config.style.colors.scheme;
    };
    translucentWithHash = mkOption {
      type = types.attrsOf types.str;
      description = "The color scheme, with transparency added and color values prefixed with '#'";
      readOnly = true;
      default = builtins.mapAttrs (_: value: "#AA${value}") config.style.colors.scheme;
    };
  };
}
