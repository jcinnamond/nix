{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    helix
    git
    os-prober
    pciutils
    usbutils
    base16-schemes
  ];
}
