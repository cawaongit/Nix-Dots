
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.spicetify-nix.nixosModules.default
      inputs.home-manager.nixosModules.home-manager
    ];

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "sasha" = import ./../../home.nix;
    };
  };

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
    dbus = {
      enable = true;
    };

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

      jack = {
        enable = true;
      };

	    pulse = {
        enable = true;
      };
    };

    gnome = {
      gnome-keyring = {
        enable = false;
      };
    };

    displayManager = {
      sddm = {
        wayland = {
          enable = true;
        };
      };
    };

    desktopManager = {
      plasma6 = {
        enable = true;
      };
    };

    xserver = {
      enable = true;
      xkb = {
        layout = "be";
	      variant = "nodeadkeys";
      };

      videoDrivers = [ "nvidia" ];
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
      unstable.firefox-devedition
      rofi-wayland
      vesktop
      hyprlock
      waybar
      unstable.libreoffice-qt6-fresh
      unzip
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
      pavucontrol
      catppuccin-cursors.mochaPeach
      curl
      hyprcursor
      texliveSmall
      playerctl
      #ciscoPacketTracer8
      gh
      pyright
      unstable.vscode
      unityhub
      putty
      qFlipper
      blender
      bottles
      lua5_1
      ripgrep
      nodejs
      tree-sitter
      mermaid-cli
      wl-clipboard
      cliphist
      ghostscript
      fzf
      obs-studio
      geogebra
      hyprshot
      lshw
      virtualbox
      wireshark
      ghostty
      lutris
      home-manager
      htop
      grim
      slurp
      dunst
      networkmanagerapplet
      mako
      gitkraken
      vscode
      jetbrains.idea-community
      udiskie
      hyprpaper
      hyprpicker
      (python3.withPackages (ps: [ ps.pygame ]))
      (pkgs.callPackage ./../../pkgs/crafted-launcher.nix {})
    ];

    plasma6.excludePackages = with pkgs.kdePackages; [
      konsole
      okular
      ark
      elisa
    ];

    sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1";
    };
  };

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  programs = {
    hyprland = {
      enable = true;
      xwayland = {
        enable = true;
      };
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

    streamdeck-ui = {
      enable = true;
      autoStart = true;
    };

    spicetify =
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
    in
    {
      enable = true;

      enabledExtensions = with spicePkgs.extensions; [
        adblock
        hidePodcasts
        fullAppDisplay
      ];
    };

    bash = {
      interactiveShellInit = ''
        if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
        then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
        fi
      '';
    };

    fish = {
      enable = true;
    };
  };

  fonts = {
    packages = with pkgs; [
      nerd-fonts.fantasque-sans-mono
      nerd-fonts.jetbrains-mono
      jetbrains-mono
      font-awesome
    ];
  };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    flipperzero = {
      enable = true;
    };

    graphics = {
      enable = true;
      enable32Bit = true;
    };

    nvidia = {
      modesetting = {
        enable = true;
      };

      open = false;
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

  xdg = {
    portal = {
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
