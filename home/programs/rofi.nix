{ pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    terminal = "${pkgs.kitty}/bin/kitty";
    plugins = with pkgs; [
      rofi-calc
    ];
    # theme = ./theme.rasi;
  };
}
