{ pkgs, ... }:
{
  security.sudo.wheelNeedsPassword = false;
  programs.zsh.enable = true;

  users.users.jc = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "scanner"
      "lp"
      "docker"
    ];
    shell = pkgs.zsh;
  };

  home-manager.users.jc = ./home.nix;
}
