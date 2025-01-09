{ ... }:
{
  imports = [
    ./colors.nix
    ./fonts.nix
  ];

  home.file."wallpaper.png".source = ./wallpapers/forest.png;
}
