{ pkgs, ... }:
{
  home.packages = with pkgs; [
    agda
    # haskellPackages.agda-language-server
  ];
}
