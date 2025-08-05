{ hostname, ... }:
{
  system.stateVersion = "24.05";
  networking.hostName = hostname;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
}
