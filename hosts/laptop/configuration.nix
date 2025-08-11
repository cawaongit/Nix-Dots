# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, inputs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.spicetify-nix.nixosModules.default
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
  ];

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      "sasha" = import ./../../home.nix;
    };
  };

  sops = {
    defaultSopsFile = "./../../secrets.yaml";
    defaultSopsFormat = "yaml";

    age = {
      keyFile = "~/.config/sops/age/keys.txt";
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

    blueman = {
      enable = true;
    };

    udisks2 = {
      enable = true;
    };

    pipewire = {
      enable = true;
      wireplumber = {
        enable = true;
      };

      extraConfig = {
        pipewire-pulse = {
          "15-force-s16-info" = {
            "pulse.rules" = [
              {
                actions = {
                  quirks = [
                    "force-s16-info"
                  ];
                };
                matches = [
                  {
                    "application.process.binary" = "my-broken-app";
                  }
                ];
              }
            ];
          };
        };
      };

      alsa = {
        enable = true;
        support32Bit = true;
      };

      pulse = {
        enable = true;
      };

      jack = {
        enable = true;
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

    mongodb = {
      enable = true;
    };

    xserver = {
      enable = true;
      xkb = {
        layout = "be";
        variant = "nodeadkeys";
      };

      videoDrivers = ["nvidia"];
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
        extraGroups = [
          "networkmanager"
          "wheel"
          "wireshark"
        ];
      };
    };

    defaultUserShell = pkgs.fish;

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
      permittedInsecurePackages = [
        "ventoy-qt5-1.1.05"
      ];
    };

    #overlay = [
    #inputs.millennium.overlays.default
    #];
  };

  # List packages installed in system profile. To search, run
  # $ nix search wget
  environment = {
    systemPackages = with pkgs; [
      unstable.firefox-devedition
      rofi-wayland
      vesktop
      hyprlock
      waybar
      unstable.libreoffice-qt6-fresh
      unzip
      mangohud
      teams-for-linux
      superfile
      lazygit
      python3
      pavucontrol
      curl
      texliveSmall
      playerctl
      ciscoPacketTracer8
      gh
      unstable.vscode
      unityhub
      putty
      qFlipper
      blender
      bottles
      nodejs
      wl-clipboard
      cliphist
      fzf
      obs-studio
      geogebra
      hyprshot
      lshw
      ghostty
      lutris
      home-manager
      htop
      grim
      slurp
      dunst
      networkmanagerapplet
      gitkraken
      vscode
      unstable.jetbrains.idea-community-bin
      udiskie
      hyprpaper
      hyprpicker
      nwg-look
      papirus-icon-theme
      brightnessctl
      hypridle
      hyprsysteminfo
      hyprpolkitagent
      kdePackages.qt6ct
      eza
      nixd
      grim
      slurp
      swappy
      libnotify
      mongodb-compass
      alejandra
      nixd
      unstable.pulsemeeter
      ventoy-full-qt
      libsForQt5.qt5.qtwayland
      vlc
      (python3.withPackages (ps: [ps.pygame]))
      (pkgs.callPackage ./../../pkgs/crafted-launcher.nix {})
    ];

    plasma6.excludePackages = with pkgs.kdePackages; [
      konsole
      okular
      ark
      elisa
      kate
    ];

    sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1";
    };
  };

  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
    };

    nixPath = [
      "nixpkgs=${inputs.nixpkgs}"
    ];
  };

  programs = {
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      xwayland = {
        enable = true;
      };
    };

    java = {
      enable = true;
    };

    nvf = {
      enable = true;
      settings = {
        vim = {
          theme = {
            enable = true;
            name = "gruvbox";
            style = "dark";
          };

          terminal = {
            toggleterm = {
              enable = true;
            };
          };

          visuals = {
            nvim-web-devicons = {
              enable = true;
            };
          };

          filetree = {
            neo-tree = {
              enable = true;
            };
          };

          git = {
            gitsigns = {
              enable = true;
            };
          };

          dashboard = {
            startify = {
              sessionPersistence = true;
            };
          };

          formatter = {
            conform-nvim = {
              enable = true;
            };
          };

          utility = {
            snacks-nvim = {
              enable = true;
              setupOpts = {
                indent = true;
                input = true;
                notifier = true;
                scope = true;
                scroll = true;
                statuscolumn = false;
                words = true;
              };
            };

            motion = {
              flash-nvim = {
                enable = true;
              };
            };
          };

          mini = {
            icons = {
              enable = true;
            };

            pairs = {
              enable = true;
            };
          };

          ui = {
            noice = {
              enable = true;
            };
          };

          tabline = {
            nvimBufferline = {
              enable = true;
            };
          };

          lsp = {
            enable = true;
            lspconfig = {
              enable = true;
            };

            trouble = {
              enable = true;
            };
          };

          languages = {
            enableTreesitter = true;
            nix = {
              enable = true;
            };

            ts = {
              enable = true;
            };

            css = {
              enable = true;
            };

            html = {
              treesitter = {
                autotagHtml = true;
              };
            };
          };

          statusline = {
            lualine = {
              enable = true;
            };
          };

          telescope = {
            enable = true;
          };

          autocomplete = {
            nvim-cmp = {
              enable = true;
            };
          };

          treesitter = {
            textobjects = {
              enable = true;
            };

            indent = {
              enable = true;
            };
          };
        };
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

    spicetify = let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in {
      enable = true;

      enabledExtensions = with spicePkgs.extensions; [
        adblock
        hidePodcasts
        fullAppDisplay
      ];
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
    libvirtd = {
      enable = true;
    };

    spiceUSBRedirection = {
      enable = true;
    };

    docker = {
      enable = true;
    };
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
