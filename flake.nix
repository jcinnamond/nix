{
  description = "NixOS & Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix";
    wired.url = "github:Toqozz/wired-notify";

    monolisa-jc.url = "path:/home/jc/fonts/monolisa-jc";
  };

  outputs =
    {
      nixpkgs,
      stylix,
      home-manager,
      monolisa-jc,
      wired,
      ...
    }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          (final: prev: {
            monolisa-jc = prev.callPackage "${monolisa-jc}" { };
          })
          wired.overlays.default
        ];
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations.nixie = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        inherit pkgs;
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.jc = import ./home.nix;
            home-manager.sharedModules = [ wired.homeManagerModules.default ];
          }
          stylix.nixosModules.stylix
        ];
      };
    };
}
