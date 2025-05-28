
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, pkgs-unstable, lib, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
      };
      efi = {
        canTouchEfiVariables = true;
      };
    };
  };

  networking = {
    hostName = "nixos";
    networkmanager = {
      enable = true;
    };
  };

  # Set your time zone.
  time = {
    timeZone = "Europe/Brussels";
  };

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "fr_BE.UTF-8";
  };

  # Configure keymap in X11
  services = {
    getty = {
      autologinUser = "sasha";
    };
    blueman = {
      enable = true;
    };
    udisks2 = {
      enable = true;
    };
    pipewire = {
      enable = true;
      alsa = {
          enable = true;
	  support32Bit = true;
	};
	pulse = {
          enable = true;
	};
    };
    xserver = {
      xkb = {
        layout = "be";
	variant = "nodeadkeys";
      };
      videoDrivers = ["hardware.nvidia.open"];
    };
  };

  # Configure console keymap
  console = {
    keyMap = "be-latin1";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    users = {
      sasha = {
        isNormalUser = true;
	description = "Sasha";
	extraGroups = [ "networkmanager" "wheel" ];
	packages = with pkgs; [];
      };
    };
    groups = {
      libvirtd = {
        members = ["sasha"];
      };
    };
  };

  # Allow unfree packages
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    systemPackages = with pkgs; [
      neovim
      kitty
      pkgs-unstable.firefox-devedition-bin
      rofi-wayland
      pkgs-unstable.discord
      hyprlock
      waybar
      pkgs-unstable.libreoffice-qt6-fresh
      pkgs-unstable.unzip
      pkgs-unstable.spotify
      libgcc
      mangohud
      neofetch
      luarocks
      gcc
      teams-for-linux
      superfile
      lazygit
      fd
      python3
      hyprpaper
      pavucontrol
      catppuccin-cursors.mochaPeach
      curl
      hyprcursor
      texliveBasic
      playerctl
      ciscoPacketTracer8
      gh
      pyright
    ];
  };

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  programs = {
    hyprland = {
      enable = true;
    };
    steam = {
      enable = true;
      gamescopeSession = {
          enable = true;
      };
    };
    git = {
      enable = true;
    };
    gamemode = {
      enable = true;
    };
    virt-manager = {
      enable = true;
    };
  };

  fonts = {
    packages = with pkgs; [
      nerd-fonts.fantasque-sans-mono
      nerd-fonts.jetbrains-mono
      font-awesome
    ];
  };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    nvidia = {
      modesetting.enable = true;
    };
  };

  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };

  security = {
    rtkit = {
      enable = true;
    };
  };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  # Did you read the comment?
  system = {
    stateVersion = "25.05";
  }; #Did you read the comment?
}
