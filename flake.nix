{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    colmena-flake.url = "github:juspay/colmena-flake";
  };

  outputs =
    inputs@{ self, ... }:
    let
      username = "ethoma";
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      imports = [
        inputs.home-manager.flakeModules.home-manager
        inputs.colmena-flake.flakeModules.default
      ];

      colmena-flake.deployment = {
        nixos = {
          targetHost = "5.78.142.27";
          targetUser = username;
          buildOnTarget = true;
        };
      };

      flake.nixosConfigurations.nixos = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = { inherit username; };

        modules = [
          ./configuration.nix
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./home.nix;
            home-manager.extraSpecialArgs = { inherit username; };
          }
        ];
      };
    };
}
