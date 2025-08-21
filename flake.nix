{
  description = "NixOS & Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wired.url = "github:Toqozz/wired-notify";
    nur = {
      url = "github:nix-community/NUR";
    };
    monolisa-jc.url = "git+ssh://git@github.com/jcinnamond/monolisa-jc";
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      monolisa-jc,
      wired,
      nur,
      ...
    }:
    let
      hosts = builtins.attrNames (builtins.readDir ./hosts);

      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          (final: prev: {
            monolisa-jc = prev.callPackage "${monolisa-jc}" { };
          })
          nur.overlays.default
          wired.overlays.default
        ];
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations = builtins.listToAttrs (
        builtins.map (hostname: {
          name = hostname;
          value = nixpkgs.lib.nixosSystem {
            inherit pkgs;
            modules = [
              ./hosts/${hostname}
              home-manager.nixosModules.home-manager
              {

                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.sharedModules = [ wired.homeManagerModules.default ];
              }
            ];
            specialArgs = { inherit inputs hostname; };
          };
        }) hosts
      );
    };
}
