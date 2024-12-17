{
  description = "My xmonad config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
  };

  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
    in
    {
      devShells."${system}".default =
        let
          pkgs = import nixpkgs {
            inherit system;
          };
          haskellPackages = pkgs.haskell.packages.ghc982;
        in
        pkgs.mkShell {
          packages = with pkgs; [
            haskellPackages.ghc
            haskellPackages.haskell-language-server
            haskellPackages.cabal-install
            haskellPackages.cabal-fmt
            haskellPackages.fourmolu
            fish
            xorg.libX11.dev
            xorg.libXrandr
            xorg.libXScrnSaver
            xorg.libXext
          ];

          shellHook = ''
            exec fish
          '';
        };
    };
}
