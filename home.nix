{ pkgs, inputs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home = {
    username = "sasha";
  };

  home = {
    homeDirectory = "/home/sasha";
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home = {
    stateVersion = "25.05"; # Please read the comment before changing.
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home = {
    packages = with pkgs; [
      kitty
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    ];
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home = {
    file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    };
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/sasha/etc/profile.d/hm-session-vars.sh
  #

  home = {
    sessionVariables = {
      # EDITOR = "emacs";
    };
  };

  services = {
    hyprpaper = {
      enable = true;
      settings = {
        preload = [
          "~/nix-dots/stupeflip.jpg"
        ];

        wallpaper = [
          ", ~/nix-dots/stupeflip.jpg"
        ];
      };
    };

    hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd ="pidof hyprlock || hyprlock";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };

        listener = [
          {
            timeout = 480;
            on-timeout = "brightnessctl -s set 10";
            on-resume = "brightnessctl -r";
          }
          {
            timeout = 480;
            on-timeout = "brightnessctl -sd intel_backlight set 0";
            on-resume = "brightnessctl -rd intel_backlight";
          }
          {
            timeout = 600;
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = 660;
            on-timeout = "hyprctl dispatch dmps off";
            on-resume = "hyprctl dispatch dmps on && brightnessctl -r";
          }
          {
            timeout = 1800;
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };

    mako = {
      enable = true;
      settings = {
        defaultTimeout = 5000;
      };
    };
  };

  #xdg = {
  #  configFile = {
  #    "lf/icons" = {
  #      source = ./icons;
  #    };
  #  };
  #};

  # Let Home Manager install and manage itself.
  programs = {
    home-manager = {
      enable = true;
    };

    lf = {
      enable = true;
      settings = {
        preview = true;
        hidden = true;
        drawbox = true;
        icons = true;
        ignoreCase = true;
      };

      commands = {
        editor-open = ''$$EDITOR $f'';
      };
    };

    kitty = {
      enable= true;
      settings = {
        font_family = "JetBrainsMono Nerd Font";
        font_size = 12;
        bold_font = "auto";
        italic_font = "auto";
        bold_italic_font = "auto";
        remember_window_size = "no";
        initial_window_width = 950;
        initial_window_height = 500;
        cursor_blink_interval = 0.5;
        cursor_stop_blinking_after = 1;
        scrollback_lines = 2000;
        wheel_scroll_min_lines = 1;
        enable_audio_bell = "no";
        window_padding_width = 10;
        hide_window_decorations = "yes";
        background_opacity = 0.7;
        dynamic_background_opacity = "yes";
        confirm_os_window_close = 0;
        selection_foreground = "none";
        selection_background = "none";
      };
    };
  };

  wayland = {
    windowManager = {
      hyprland = {
        enable = true;

        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
        plugins = [
          inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprbars

          inputs.Hyprspace.packages.${pkgs.system}.Hyprspace
        ];

        settings = {
          "$terminal" = "kitty";
          "$fileManager" = "dolphin";
          "$menu" = "rofi";

          exec-once = [
            "nm-applet --indicator"
            "waybar"
            "udiskie"
            "hyprpaper"
            "hypridle"
            "hyprpolkitagent"
            "mako"
            "wl-paste --type text --watch cliphist store"
            "wl-paste --type image --watch cliphist store"
            "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
          ];

          general = {
            resize_on_border = false;

            allow_tearing = false;

            layout = "dwindle";
          };

          decoration = {
            rounding = 10;
            rounding_power = 2;

            active_opacity = 1.0;
            inactive_opacity = 1.0;

            shadow = {
              enabled = true;
              range = 10;
              render_power = 3;
              color = "rgba(1a1a1aee)";
            };

            blur = {
              enabled = true;
              size = 3;
              passes = 1;

              vibrancy = 0.1696;
            };
          };

          animations = {
            enabled = "yes, please :)";

            bezier = [
              "easeOutQuint,0.23,1,0.32,1"
              "easeInOutCubic,0.65,0.05,0.36,1"
              "linear,0,0,1,1"
              "almostLinear,0.5,0.5,0.75,1.0"
              "quick,0.15,0,0.1,1"
            ];

            animation = [
              "global, 1, 10, default"
              "border, 1, 5.39, easeOutQuint"
              "windows, 1, 4.79, easeOutQuint"
              "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
              "windowsOut, 1, 1.49, linear, popin 87%"
              "fadeIn, 1, 1.73, almostLinear"
              "fadeOut, 1, 1.46, almostLinear"
              "fade, 1, 3.03, quick"
              "layers, 1, 3.81, easeOutQuint"
              "layersIn, 1, 4, easeOutQuint, fade"
              "layersOut, 1, 1.5, linear, fade"
              "fadeLayersIn, 1, 1.79, almostLinear"
              "fadeLayersOut, 1, 1.39, almostLinear"
              "workspaces, 1, 1.94, almostLinear, fade"
              "workspacesIn, 1, 1.21, almostLinear, fade"
              "workspacesOut, 1, 1.94, almostLinear, fade"
            ];
          };

          dwindle = {
            pseudotile = true;
            preserve_split = true;
          };

          master = {
            new_status = "master";
          };

          misc = {
            force_default_wallpaper = 0;
            disable_hyprland_logo = false;
          };

          input = {
            kb_layout = "be";

            follow_mouse = 1;

            sensitivity = 0;

            touchpad = {
              natural_scroll = false;
            };
          };

          gestures = {
            workspace_swipe = false;
          };

          device = {
            name = "epic-mouse-v1";
            sensitivity = "-0.5";
          };

          "$mainMod" = "SUPER";

          bind = [
            "$mainMod, Q, exec, $terminal"
            "$mainMod, C, killactive,"
            "$mainMod, M, exit,"
            "$mainMod, E, exec, $fileManager"
            "$mainMod, V, togglefloating,"
            "$mainMod, SPACE, exec, $menu -show drun -show-icons"
            "$mainMod, P, pseudo,"
            "$mainMod, J, togglesplit,"
            "$mainMod, L, exec, hyprlock"
            ",Print, exec, grim -g \"$(slurp)\" - | swappy -f -"
            "$mainMod SHIFT, C, exec, hyprpicker"

            "$mainMod, left, movefocus, l"
            "$mainMod, right, movefocus, r"
            "$mainMod, up, movefocus, u"
            "$mainMod, down, movefocus, d"

            "$mainMod, KP_End, workspace, 1"
            "$mainMod, KP_Down, workspace, 2"
            "$mainMod, KP_Next, workspace, 3"
            "$mainMod, KP_Left, workspace, 4"
            "$mainMod, KP_Begin, workspace, 5"
            "$mainMod, KP_Right, workspace, 6"
            "$mainMod, KP_Home, workspace, 7"
            "$mainMod, KP_Up, workspace, 8"
            "$mainMod, KP_Prior, workspace, 9"
            "$mainMod, KP_Insert, workspace, 10"

            "$mainMod SHIFT, KP_End, movetoworkspace, 1"
            "$mainMod SHIFT, KP_Down, movetoworkspace, 2"
            "$mainMod SHIFT, KP_Next, movetoworkspace, 3"
            "$mainMod SHIFT, KP_Left, movetoworkspace, 4"
            "$mainMod SHIFT, KP_Begin, movetoworkspace, 5"
            "$mainMod SHIFT, KP_Right, movetoworkspace, 6"
            "$mainMod SHIFT, KP_Home, movetoworkspace, 7"
            "$mainMod SHIFT, KP_Up, movetoworkspace, 8"
            "$mainMod SHIFT, KP_Prior, movetoworkspace, 9"
            "$mainMod SHIFT, KP_Insert, movetoworkspace, 10"

            "$mainMod, S, togglespecialworkspace, magic"
            "$mainMod SHIFT, S, movetoworkspace, special:magic"

            "$mainMod, mouse_down, workspace, e+1"
            "$mainMod, mouse_up, workspace, e-1"
            "$mainMod, G, exec, hyprctl dispatch overview:toggle"
          ];

          bindm = [
            "$mainMod, mouse:272, movewindow"
            "$mainMod, mouse:273, resizewindow"
          ];

          windowrule = [
            "suppressevent maximize, class:.*"

            "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"

            "float, class:.*"

            "opacity 0.0 override, class:^(xwaylandvideobridge)$"
            "noanim, class:^(xwaylandvideobridge)$"
            "noinitialfocus, class:^(xwaylandvideobridge)$"
            "maxsize 1 1,class:^(xwaylandvideobridge)$"
            "maxsize 1 1,class:^(xwaylandvideobridge)$"
          ];

          plugin = {
            hyprbars = {
              bar_color = "rgb(30, 30, 30)";
              bar_height = 30;
              "col.text" = "rgb(200, 200, 200)";
              bar_text_size = 12;
              bar_text_font = "Jetbrains Mono Nerd Font Mono Bold";
              bar_buttons_alignment = "left";
              bar_precedence_over_border = true;
              bar_padding = 5;
              bar_button_padding = 5;
              hyprbars-button =
              [
                "rgb(ff4040), 16, , hyprctl dispatch killactive"
                "rgb(eeee11), 16, , hyprctl dispatch togglefloating"
              ];
            };
          };
        };
      };
    };
  };
}
