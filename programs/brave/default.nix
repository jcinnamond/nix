{ pkgs, ... }:
{
  programs.brave = {
    enable = true;
    package = pkgs.brave;
    extensions = [
      {
        # 1password
        id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa";
      }
      {
        # consent-o-matic
        id = "mdjildafknihdffpkfmmpnpoiajfjnjd";
      }
      {
        # dark reader
        id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";
      }
      {
        # ublock origin
        id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
      }
      {
        # reader view
        id = "ecabifbgmdmgdllomnfinbmaellmclnh";
      }
    ];
  };
}
