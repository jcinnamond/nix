{ pkgs, ... }:
{
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
}
