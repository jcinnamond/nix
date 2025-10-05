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

  imports = [
    # Don't use homemanager for brave as it's missing extra config opts
    ../programs/brave
  ];

  home-manager.users.jc = ./home.nix;
}
