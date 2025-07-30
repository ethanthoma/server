{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ self, ... }: 
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.home-manager.flakeModules.home-manager ];

      systems = [ "x86_64-linux" ];

      flake = let username = "ethoma"; in {
        nixosConfigurations.nixos = inputs.nixpkgs.lib.nixosSystem {
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
  };
}
