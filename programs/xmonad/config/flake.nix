{
  description = "My xmonad config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    xmonad-jc-extra.url = "github:jcinnamond/xmonad-jc-extra";
  };

  outputs =
    { nixpkgs, xmonad-jc-extra, ... }:
    let
      system = "x86_64-linux";
    in
    {
      devShells."${system}".default =
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              (final: prev: {
                haskellPackages = prev.haskellPackages.override {
                  overrides = hfinal: hprev: {
                    xmonad-jc-extra = hfinal.callCabal2nix "xmonad-jc-extra" xmonad-jc-extra { };
                  };
                };
              })
            ];
          };
        in
        pkgs.haskellPackages.shellFor {
          packages = p: [
            (p.callCabal2nix "my-xmonad" ./. { })
          ];
          buildInputs = with pkgs.haskellPackages; [
            cabal-install
            cabal-gild
            fourmolu
            hlint
            haskell-language-server
          ];
          nativeBuildInputs = with pkgs; [
            xorg.libX11.dev
            xorg.libXrandr
            xorg.libXScrnSaver
            xorg.libXext
          ];
          withHoogle = false;
        };
    };
}
