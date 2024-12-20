{ config, pkgs, inputs, ... }:
{
  imports = [
#    inputs.hyprland.homeManagerModules.default

    ../../optional/dunst.nix
    ../../optional/kitty.nix
    ../../optional/nerdfonts.nix
    ../../optional/swaylock.nix
    ../../optional/waybar.nix
    ../../optional/wofi.nix
  ];

  home.packages = [
    pkgs.wl-clipboard
  ];
  xdg.portal.configPackages = [ inputs.hyprland.packages.${pkgs.system}.hyprland ];
  xdg.portal.extraPortals = [ inputs.hyprland.packages.${pkgs.system}.hyprland ];
  #xdg.portal.extraPortals = [ pkgs.hyprland ];
  #xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  #xdg.portal.configPackages = [ pkgs.xdg-desktop-portal-hyprland ];
  wayland.windowManager.hyprland = {
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    plugins = [
      inputs.hyprland-plugins.packages."${pkgs.system}".borders-plus-plus
    ];
    settings = {
      "$mod" = "SUPER";

      # monitor = ",preferred,auto,1.0";

      "plugin:borders-plus-plus" = {
        add_borders = 1;
        "col.border_1" = "rgb(00ff00)";

        border_size_1 = -1;

        natural_rounding = "yes";
      };

      input = {
        kb_layout = "us";
        follow_mouse = "1";
        touchpad = {
          natural_scroll = "true";
          "tap-to-click" = "false";
          "disable_while_typing" = "true";
        };
        sensitivity = "0"; # -1.0 - 1.0, 0 means no modification.
      };

      general = {
        gaps_in = "5";
        gaps_out = "20";
        border_size = "3";
        "col.active_border" = "rgba(ffffffd0) rgba(ffffffa0) 45deg";
        "col.inactive_border" = "rgba(ffffff00)";

        layout = "dwindle";

        allow_tearing = "false";
      };

      decoration = {
      # See https://wiki.hyprland.org/Configuring/Variables/ for more

        rounding = "10";

        blur = {
          enabled = "true";
          size = "3";
          passes = "1";
          vibrancy = "0.1696";
        };

        #drop_shadow = "true";
        #shadow_range = "4";
        #shadow_render_power = "3";
        #"col.shadow" = "rgba(1a1a1aee)";
      };

      animations = {
        enabled = "true";

        # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
        pseudotile = "true"; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = "true"; # you probably want this
      };

      master = {
        # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
        # new_is_master = "true";
      };

      gestures = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        workspace_swipe = "false";
      };

      misc = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        force_default_wallpaper = "0"; # Set to 0 to disable the anime mascot wallpapers
      };

      windowrule = [
        "float,^(lutris)$"
        "float,^(virt-manager)$"
        "float,title:^(Friends List)$"
        "float,^(pavucontrol)$"
      ];

      windowrulev2 = [
        "tile,class:Google-chrome,title:^(Inbox .*)$"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      bind = [
        "$mod, C, killactive,"
        "$mod, Q, exit"
        "$mod, E, exec, ${pkgs.xfce.thunar}/bin/thunar"
        "$mod, V, togglefloating,"
        "$mod, P, pseudo, # dwindle"
        "$mod, J, togglesplit, # dwindle"
        "$mod SHIFT, F, fullscreen"
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        "$mod, S, togglespecialworkspace, magic"
        "$mod SHIFT, S, movetoworkspace, special:magic"
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
          builtins.concatLists (builtins.genList (
              x: let
                ws = let
                  c = (x + 1) / 10;
                in
                  builtins.toString (x + 1 - (c * 10));
              in [
                "$mod, ${ws}, workspace, ${toString (x + 1)}"
                "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
              ]
            )
            10)
        );
    };
  };
}
