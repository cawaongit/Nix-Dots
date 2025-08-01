{
  description = "A very basic flake";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-25.05";
    };

    nixpkgs-unstable = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };

    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
      submodules = true;
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };

    hy3 = {
      url = "github:outfoxxed/hy3?href=hl0.50.0";
      inputs.hyprland.follows = "hyprland";
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };
  };

  outputs = { nixpkgs, nixpkgs-unstable, home-manager, hyprland, hyprland-plugins, ... } @ inputs:
    let
      baseModules = [
        ./modules/overlays.nix
      ];
    in
  {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };

      modules = baseModules ++ [
        ./hosts/laptop/configuration.nix
      ];
    };
  };
}
