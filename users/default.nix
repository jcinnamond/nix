{ ... }:
{
  security.sudo.wheelNeedsPassword = false;
  programs.zsh.enable = true;

  imports = [
    ./jcinnamond.nix
  ];
}
