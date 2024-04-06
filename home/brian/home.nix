{ config, pkgs, inputs, ... }:

{
  # nixpkgs.config.allowUnfree = true;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "brian";
  home.homeDirectory = "/home/brian";

  home.stateVersion = "23.11"; # Please read the comment before changing.

  fonts.fontconfig.enable = true;

  programs.bash = {
    enable = true;
    shellAliases = {
      h = "dbus-launch --exit-with-session Hyprland";
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    # enableAutosuggestions = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history.size = 10000;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "gh" "ssh-agent" ];
    };
    plugins = [
      { name = "powerlevel10k"; src = pkgs.zsh-powerlevel10k; file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme"; }
      { name = "fzf-tab"; src = pkgs.zsh-fzf-tab; file = "share/fzf-tab/fzf-tab.zsh.theme"; }
    ];
    shellAliases = {
      tm = "tmux new-session -A -s main";
      emacs = "emacs -nw";
    };
    initExtra = ''
      source ~/.p10k.zsh
      '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    tmux.enableShellIntegration = true;
  };

  programs.eza = {
    enable = true;
    # enableZshIntegration = true;
    # enableBashIntegration = false; # not in 23.11; move to unstable or wait until 24.05
    git = true;
    icons = true;
  };

  programs.git = {
    enable = true;
    userName = "Brian H. Ward";
    userEmail = "glyphrider@gmail.com";
    signing = {
      key = "A1268F7E5E7EBFDF";
      signByDefault = true;
    };
    aliases = {
      lol = "log --pretty=oneline --abbrerv-commit --graph --decorate";
      los = "log --show-signature";
    };
    extraConfig = {
      pull = { rebase = "false"; };
      init = { defaultBranch = "main"; };
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper = {
      enable = true;
      hosts = [ "github.com" "gists.github.com" ];
    };
  };

  programs.emacs = {
    enable = true;
  };

  programs.tmux = {
    enable = true;
    mouse = true;
    shortcut = "Space";
    baseIndex = 1;
    plugins = with pkgs.tmuxPlugins; [
      sensible
      vim-tmux-navigator
      yank
    ];
  };

  programs.vim = {
    enable = true;
    settings = {
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      number = true;
      relativenumber = true;
    };
  };

  home.packages = with pkgs; [
    awscli2
    bitwarden
    blueman
    cmatrix
    cmus
    cowsay
    discord
    dunst
    erlang
    ffmpeg
    firefox
    fortune
    git
    gh # github cli
    gimp
    gnome3.adwaita-icon-theme
    google-chrome
    grim
    htop
    kitty
    lollypop
    lutris
    neofetch
    nerdfonts
    networkmanagerapplet
    newsboat
    obs-studio
    pavucontrol # pipewire -> pulseaudio
    rebar3 # build tool for erlang; needed for erlang-ls in neovim
    rustup # used to install a version of rust
    signify # verify package signatures, like for GrapheneOS
    slack
    slurp
    steam
    swappy
    swww
    tela-circle-icon-theme 
    tor
    unzip # needed for the elixir-ls in neovim
    vivaldi
    vscode
    waybar
    wineWowPackages.stable # both 64-bit and 32-bit wine(s)
    wireshark # wireshark seems to need both the package *and* the programs.wireshark.enable = true
    wl-clipboard
    xdg-user-dirs
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    plugins = [
      inputs.hyprland-plugins.packages."${pkgs.system}".borders-plus-plus
    ];
    settings = {
      "$mod" = "SUPER";

      monitor = ",preferred,auto,1.0";

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

        drop_shadow = "true";
        shadow_range = "4";
        shadow_render_power = "3";
        "col.shadow" = "rgba(1a1a1aee)";
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
        new_is_master = "true";
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
        "$mod, Return, exec, kitty"
        "$mod, C, killactive,"
        "$mod, Q, exit"
        "$mod, L, exec, swaylock"
        "$mod, E, exec, thunar"
        "$mod, V, togglefloating,"
        "$mod, R, exec, wofi --show drun"
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

      exec-once = [
        "${pkgs.waybar}/bin/waybar"
        "${pkgs.blueman}/bin/blueman-applet"
        "${pkgs.networkmanagerapplet}/bin/nm-applet"
        "${pkgs.swww}/bin/swww init"
        ];
    };
  };

  programs.waybar = {
    enable = true;
    settings = [{
      layer = "top";
      position = "top";
      mod = "dock";
      exclusive = true;
      passthrough = false;
      gtk-layer-shell = true;
      height = 24;
      margin-left = 5;
      margin-right = 5;
      margin-top = 5;
      modules-left = [
        "wlr/taskbar"
        "hyprland/workspaces"
      ];
      modules-center = [
        "hyprland/window"
      ];
      modules-right = [
          "tray"
          "battery"
          "temperature"
          "pulseaudio"
          "clock"
      ];
  
      "wlr/taskbar" = {
        format = "{icon}";
        icon-size = 16;
        all-outputs = true;
        tooltip-format = "{name} - {title}";
        on-click = "activate";
        ignore-list = [
          "wofi"
        ];
      };
  
      "hyprland/window" = {
      };
  
      "hyprland/workspaces" = {
          disable-scroll = true;
          on-click = "activate";
      };
  
      tray = {
          icon-size = 16;
          spacing = 10;
      };
  
      battery = {
        format = "{icon}";
        format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" ];
        format-full = "󱟢";
        format-charging = "󰂄";
      };
  
      temperature = {
          hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
          format = "{icon} {temperatureF}°F";
          format-alt-click = "click-right";
          format-alt = "{icon} {temperature}°C";
          format-icons = [ "" "" "" "" "" ];
      };
      
      pulseaudio = {
        format-icons = [ "󰕿" "󰖀" "󰕾" ];
        format = "{icon} {volume}%";
      };
  
      clock = {
        format = "{:%I:%M%p}";
        tooltip-format = "{:  %A, %B %e %Y}";
      };
  
    }];
    style = ''
      * {
          border: none;
          /* font-family: "NotoMono Nerd Font"; */
          font-family: "Arimo Nerd Font Propo";
          font-weight: bold;
          font-size: 16px;
          min-height: 0;
      }
      
      window#waybar {
        padding: 2px;
        background: rgba(0,0,0,0.0);
        color: #00ff00;
        margin: 2px 5px;
        border-radius: 5px;
        padding: 1px 5px;
      }
      
      tooltip {
          background: #1e1e2e;
          opacity: 0.8;
          border-radius: 5px;
          border-width: 2px;
          border-style: solid;
          border-color: #11111b;
      }
      
      tooltip label{
          color: #cdd6f4;
      }
      
      #workspaces button {
          padding: 1px 5px;
          color: #00ff00;
          margin: 2px 5px;
      }
      
      #workspaces button.active {
          color: #000000;
          background: #00ff00;
          border-radius: 10px;
      }
      
      #workspaces button:hover {
          background: #40ff40;
          color: #00d000;
          border-radius: 5px;
      }
      
      #window,
      #clock,
      #battery,
      #tray,
      #temperature,
      #workspaces,
      #taskbar {
          background: rgba(0, 0, 0, 0.2);
          opacity: 1;
          padding: 0px 8px;
          margin: 0px 3px;
          border: 0px;
          border-radius: 5px;
      }
      
      #temperature.critical {
          color: #ff0000;
      }
      
      #workspaces {
          padding-right: 0px;
          padding-left: 5px;
      }
      
      #window {
          background: rgba(0,0,0,0.2);
          border-radius: 5px;
          margin-left: 0px;
          margin-right: 0px;
      }
    '';
  };

  programs.wofi = {
    enable = true;
    settings = {
      width = 600;
      height = 300;
      location = "center";
      show = "drun";
      prompt = "Search...";
      filter_rate = 100;
      allow_markup = true;
      no_actions = true;
      halign = "fill";
      orientation = "vertical";
      content_halign = "fill";
      insensitive = true;
      allow_images = true;
      image_size = 40;
      gtk_dark = true;
      dynamic_lines = true;
    };
    style = ''
      window {
          margin: 0px;
          border: 5px solid #1e1e2e;
          background-color: #cdd6f4;
          border-radius: 0px;
      }
      
      #input {
          padding: 4px;
          margin: 4px;
          padding-left: 20px;
          border: none;
          color: #cdd6f4;
          font-weight: bold;
          background-color: #1e1e2e;
         	outline: none;
          border-radius: 15px;
          margin: 10px;
          margin-bottom: 2px;
      }
      #input:focus {
          border: 0px solid #1e1e2e;
          margin-bottom: 0px;
      }
      
      #inner-box {
          margin: 4px;
          border: 10px solid #1e1e2e;
          color: #cdd6f4;
          font-weight: bold;
          background-color: #1e1e2e;
          border-radius: 15px;
      }
      
      #outer-box {
          margin: 0px;
          border: none;
          border-radius: 15px;
          background-color: #1e1e2e;
      }
      
      #scroll {
          margin-top: 5px;
          border: none;
          border-radius: 15px;
          margin-bottom: 5px;
          /* background: rgb(255,255,255); */
      }
      
      #img:selected {
          background-color: #89b4fa;
          border-radius: 15px;
      }
      
      #text:selected {
          color: #cdd6f4;
          margin: 0px 0px;
          border: none;
          border-radius: 15px;
          background-color: #89b4fa;
      }
      
      #entry {
          margin: 0px 0px;
          border: none;
          border-radius: 15px;
          background-color: transparent;
      }
      
      #entry:selected {
          margin: 0px 0px;
          border: none;
          border-radius: 15px;
          background-color: #89b4fa;
      }
    '';
  };

  programs.swaylock = {
    enable = true;
    settings = {
      indicator = true;
      clock = true;
      screenshots = true;
      effect-greyscale = true;
      effect-blur="4x4";
      effect-vignette="0:0.5";
      indicator-radius=200;
      indicator-thickness=50;
    };
    package = pkgs.swaylock-effects;
  };

  services.dunst = {
    enable = true;
    settings = {
      global = {
        frame_width = 1;
        frame_color = "#000000";
        font = "Arimo Nerd Font Propo 10";
        markup = "yes";
        format = "<big><b>%s</b></big> %p\n%b";
        sort = "yes";
        indicate_hidden = "yes";
        alignment = "left";
        show_age_threshold = 60;
        word_wrap = "no";
        ignore_newline = "no";
        height = 256;
        width = "(384, 512)";
        offset = "32x32";
        shrink = "no";
        transparency = 15;
        corner_radius = 7;
        idle_threshold = 120;
        monitor = 0;
        follow = "keyboard";
        sticky_history = "yes";
        history_length = 20;
        show_indicators = "yes";
        line_height = 0;
        padding = 8;
        horizontal_padding = 10;
        icon_position = "left";
        icon_path = "${pkgs.tela-circle-icon-theme}/share/icons/Tela-circle/16/actions/:${pkgs.tela-circle-icon-theme}/share/icons/Tela-circle/16/panel/:";
        max_icon_size = 128;
      };
      urgency_low = {
        background = "#000000";
        foreground = "#808080";
        timeout = 15;
      };
      urgency_normal = {
        background = "#141003";
        foreground = "#e1c564";
        timeout = 15;
        icon = "bell";
      };
      urgency_critical = {
        frame_color = "#ff0000";
        background = "#fff8dc";
        foreground = "#ff0000";
        timeout = 0;
        icon = "firewall-applet-panic";
      };
    };
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage plain files is through 'home.file'.
  home.file = {
    ".emacs".text = ''
      (setq erlang-root-dir "${pkgs.erlang}/lib/erlang/")
      (setq erlang-lib-dir (concat erlang-root-dir "lib/"))
      (setq erlang-bin-dir (concat erlang-root-dir "bin/"))
      (setq erlang-tools (car (directory-files erlang-lib-dir nil "^tools-.*")))
      (setq erlang-mode-dir (concat erlang-lib-dir erlang-tools "/emacs"))
      (setq load-path (cons erlang-mode-dir load-path))
      (setq exec-path (cons erlang-bin-dir exec-path))
      (require 'erlang-start)
      '';
    ".config/kitty/kitty.conf".text = ''
      background_opacity 0.6
      font_family FiraCode Nerd Font
      shell env SHELL=${pkgs.zsh}/bin/zsh ${pkgs.zsh}/bin/zsh
      '';
    "Pictures/the-matrix-resurrection-digital-rain-city-street.jpeg".source = builtins.fetchurl { url = "https://static1.colliderimages.com/wordpress/wp-content/uploads/2023/05/the-matrix-resurrection-digital-rain-city-street.jpeg"; sha256 = "fbf0647e8f009e8d4b62974836ee2bde65b65aeafa1725db332ce4924916dba8"; };
    ".p10k.zsh".source = ./p10k.zsh;
    ".newsboat/urls".source = ./newsboat-urls;
  };

  home.activation.xdg = ''
    echo '> using xdg-user-dirs to ensure "standard" folders exist in home'
    "${pkgs.xdg-user-dirs}/bin/xdg-user-dirs-update"
    '';

  home.activation.ssh-dir = ''
    umask 077 && mkdir -pv ~/.ssh
    '';
  home.sessionVariables = {
    EDITOR = "vim";
    VIRSH_DEFAULT_CONNECT_URI = "qemu:///system";
  };

  programs.home-manager.enable = true;
}
