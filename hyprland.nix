{ inputs, pkgs, ... }:
{
  programs.regreet.enable = true;
  programs.waybar.enable = true;
  programs.hyprlock.enable = true;

  programs.hyprland = {
    enable = true;
    withUWSM = true;

    # set the flake package
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # make sure to also set the portal package, so that they are in sync
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };
}
