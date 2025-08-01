{ config, pkgs, inputs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "sasha";
  home.homeDirectory = "/home/sasha";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
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

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
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
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  wayland = {
    windowManager = {
      hyprland = {
        enable = true;
        package = pkgs.hyprland;
        portalPackage = pkgs.xdg-desktop-portal-hyprland;

        plugins = with pkgs.hyprlandPlugins; [ 
          borders-plus-plus 
        ];

        settings = {
          "$terminal" = "ghostty";
          "$fileManager" = "dolphin";
          "$menu" = "rofi";

          exec-once = [
            "swww"
            "nm-applet --indicator"
            "waybar"
            "mako"
            "udiskie"
          ];

          general = {
            gaps_in = 5;
            gaps_out = 20;

            border_size = 2;

            "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
            "col.inactive_border" = "rgba(595959aa)";

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
              range = 4;
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
            "$mainMod, R, exec, $menu -show drun -show-icons"
            "$mainMod, P, pseudo,"
            "$mainMod, J, togglesplit,"
            "$mainMod, L, exec, hyprlock"
            "$mainMod SHIFT, PRINT, exec, grim -g slurp - | wl-copy"

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
          ];

          bindm = [
            "$mainMod, mouse:272, movewindow"
            "$mainMod, mouse:273, resizewindow"
          ];

          windowrule = [
            "suppressevent maximize, class:.*"

            "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
          ];

          plugin = {
            # hy3 = { - No Hy3 installed
            # 
            # };
          };

          "plugin:borders-plus-plus" = {
            add_borders = 1;

            "col.border_1" = "rgb(ffffff)";
            "col.border_2" = "rgb(2222ff)";

            border_size_1 = 10;
            border_size_2 = -1;

            natural_rounding = "yes";
          };
        };
      };
    };
  };
}
