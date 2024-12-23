{ pkgs, lib, ... }:
{
  programs.rofi = {
    enable = true;
    terminal = "${pkgs.kitty}/bin/kitty";
    plugins = with pkgs; [
      rofi-calc
    ];
    font = lib.mkForce "MonolisaJc Nerd Font 14";
  };
}
