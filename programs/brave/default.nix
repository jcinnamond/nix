{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.brave ];

  # configure brave via nixos' chromium settings
  programs.chromium = {
    enable = true;
    extensions = [
      "aeblfdkhhhdcdjpifhhbdiojplfjncoa" # 1password
      "mdjildafknihdffpkfmmpnpoiajfjnjd" # consent-o-matic
      "eimadpbcbfnmbkopoojfekhnkhdbieeh" # dark reader
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
    ];
    extraOpts = {
      PasswordManagerEnabled = false;
      BraveAIChatEnabled = false;
      BraveNewsDisabled = true;
      BravePlaylistEnabled = false;
      BraveRewardsDisabled = true;
      BraveStatsPingEnabled = false;
      BraveTalkDisabled = true;
      BraveVPNDisabled = true;
      BraveWalletDisabled = true;
    };
  };
}
