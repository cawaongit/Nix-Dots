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
          follows = "nixpkgs-unstable";
        };
      };
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs = {
        hyprland = {
          follows = "hyprland";
        };
      };
    };

    Hyprspace = {
      url = "github:KZDKM/Hyprspace";
      inputs = {
        hyprland = {
          follows = "hyprland";
        };
      };
    };

    nvf = {
      url = "github:notashelf/nvf";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };

    millennium = {
      url = "git+https://github.com/SteamClientHomebrew/Millennium";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, hyprland, hyprland-plugins, nvf, sops-nix, millennium, stylix, ... } @ inputs:
    let
      baseModules = [
        ./modules/overlays.nix
      ];
    in
  {
    nixosConfigurations = {

      laptop = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };

        system = "x86_64-linux";
        modules = baseModules ++ [
          ./hosts/laptop/configuration.nix
          nvf.nixosModules.default
        ];
      };

      iso = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = baseModules ++ [
          ./hosts/iso/configuration.nix
        ];
      };
    };
  };
}
