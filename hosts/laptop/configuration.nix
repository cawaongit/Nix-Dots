
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.spicetify-nix.nixosModules.default
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
    enable = true;
    xkb = {
      layout = "be";
	    variant = "nodeadkeys";
    };

    videoDrivers = [
      "modesetting"
      "nvidia"
    ];

    displayManager = {
      sddm = {
        enable = true;
        theme = "catppuccin-mocha";
        package = pkgs.kdePackages.sddm;
        wayland = {
          enable = true;
        };
      };
    };

      desktopManager = {
        gnome = {
          enable = true;
        };
      };
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

  # List packages installed in system profile. To search, run
  # $ nix search wget
  environment = {
    systemPackages = with pkgs; [
      neovim
      kitty
      unstable.firefox-devedition-bin
      rofi-wayland
      vesktop
      hyprlock
      waybar
      unstable.libreoffice-qt6-fresh
      unzip
      spotify
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
      texliveSmall
      playerctl
      ciscoPacketTracer8
      gh
      pyright
      vscode
      unityhub
      putty
      qFlipper
      blender
      bottles
      lua5_1
      ripgrep
      nodejs_24
      tree-sitter
      mermaid-cli
      wl-clipboard
      ghostscript
      fzf
      obs-studio
      geogebra
      hyprshot
      lshw
      (catppuccin-sddm.override {
        flavor = "mocha";
        font = "Noto Sans";
        fontSize = "9";
        #background = "${./wallpaper.png}";
        loginBackground = true;
      })
      (pkgs.bottles.override {
        removeWarningPopup = true;
      })
    ];
  };

  environment.gnome.excludePackages = with pkgs; [
    geary
    gnome-calculator
    gnome-calendar

  ];

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

    spicetify =
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
    in 
    {
      enable = true;
      theme = spicePkgs.themes.catppuccin;
      colorScheme = "mocha";
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
      modesetting = {
        enable = true;
      };

      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };

        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:2:0:0";
      };
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
