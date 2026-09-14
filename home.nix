{ inputs, config, pkgs, lib, ... }:

let
  wallpaper = pkgs.runCommand "wallpaper-nix-nineish-catppuccin-macchiato" { } ''
    cp ${./wallpapers/nix-wallpaper-nineish-catppuccin-macchiato.png} $out
  '';

  geProtonVersion = "11-5";
  geProton = pkgs.stdenv.mkDerivation {
    pname = "GE-Proton";
    version = geProtonVersion;
    src = pkgs.fetchurl {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton${geProtonVersion}/GE-Proton${geProtonVersion}-x86_64.tar.gz";
      sha256 = "0xcaqdfzjscyl02qi9ij2fhcallrfn24vi4nkfs7s11wbyrc8hyy";
    };
    dontConfigure = true;
    dontBuild = true;
    installPhase = ''
      mkdir -p $out
      tar -xzf $src -C $out --strip-components=1
    '';
  };
in
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Brian H. Ward";
        email = "glyphrider@gmail.com";
        signingkey = "C080C200A93516B45B690469A1268F7E5E7EBFDF";
      };
      commit = {
        gpgsign = true;
      };
    };
  };
  programs.gh = {
    enable = true;
    gitCredentialHelper = {
      enable = true;
      hosts = [
        "https://github.com"
        "https://gist.github.com"
      ];
    };
  };

  home.packages = with pkgs; [
    cmus
    brightnessctl
    fuzzel
    tofi
    tree
    claude-code
    neovim
    gcc
    unzip
    fastfetch
    minicom
    grim
    slurp
    jq
    inputs.hyprpaper.packages.${pkgs.stdenv.hostPlatform.system}.hyprpaper
    google-chrome
    (writeShellApplication {
      name = "toggle-touchpad";
      runtimeInputs = [ jq ];
      text = ''
        DEVICE_RAW=$(hyprctl devices -j | jq -r '[.mice[] | select(.name | test("(?i)touchpad|trackpad"))][0].name // empty')

        if [ -z "$DEVICE_RAW" ]; then
          hyprctl notify -1 3000 0 "No touchpad device found"
          exit 1
        fi

        STATE_FILE="/tmp/touchpad-disabled"
        if [ -f "$STATE_FILE" ]; then
          hyprctl keyword "device[$DEVICE_RAW]:enabled" true
          rm "$STATE_FILE"
          hyprctl notify 1 2000 0 "Touchpad enabled"
        else
          hyprctl keyword "device[$DEVICE_RAW]:enabled" false
          touch "$STATE_FILE"
          hyprctl notify 1 2000 0 "Touchpad disabled"
        fi
      '';
    })
  ];

  programs.firefox = {
    enable = true;
    configPath = ".mozilla/firefox";
    profiles.brian = {
      isDefault = true;
      settings = {
        "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
        "ui.systemUsesDarkTheme" = 1;
      };
      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        bitwarden
        ublock-origin
      ];
    };
  };

  home.sessionVariables = {
    EDITOR = "vim";
  };

  home.shell = {
    enableZshIntegration = true;
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    gtk4.theme = config.gtk.theme;
  };

  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    package = pkgs.capitaine-cursors;
    #name = "Capitaine Cursors - White";
    name = "capitaine-cursors-white";
    size = 24;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autocd = true;
    autosuggestion = {
      enable = true;
      strategy = [
        "history"
        "completion"
      ];
    };
    history = {
      append = true;
      findNoDups = true;
      ignoreAllDups = true;
      save = 10000;
      size = 10000;
      saveNoDups = true;
      share = true;
    };
    shellAliases = {
      "hyprland" = "uwsm start hyprland-uwsm.desktop";
      "htop" = "nix run nixpkgs#htop";
      "emacs" = "nix run nixpkgs#emacs-nox";
      "fetch" = "nix run nixpkgs#fetch";
      "afetch" = "nix run nixpkgs#afetch";
      "nvtop" = "nix run nixpkgs#nvtopPackages.amd";
      "pyfa" = "nix run nixpkgs#pyfa";
    };
    syntaxHighlighting = {
      enable = true;
    };
    initContent = ''
      prompt off
      export PS1="%F{magenta}%n@%m%f 󱄅 %F{blue}%~%f %(?.%F{green}.%F{red})>>>%f "
      if [ -z "$XDG_RUNTIME_DIR" ]; then
        export XDG_RUNTIME_DIR=/run/user/$(id -u)
      fi
      [[ "$TERM" =~ "tmux" || "$TERM" =~ "screen" ]] || fastfetch
    '';
  };

  programs.vim = {
    enable = true;
    extraConfig = ''
      filetype plugin indent on
      set tabstop=2
      set shiftwidth=2
      set expandtab
      set autoindent
      set number
      set relativenumber
      set backspace=indent,eol,start
      set incsearch
      set hlsearch
      set ignorecase
      set smartcase
      set wildmenu
      set scrolloff=5
      set clipboard=unnamedplus
      syntax on
      nnoremap <Esc> :noh<CR>
    '';
  };

  programs.tmux = {
    enable = true;
    shortcut = "Space";
    baseIndex = 1;
    mouse = true;
    keyMode = "vi";
    plugins = with pkgs.tmuxPlugins; [
      sensible
      vim-tmux-navigator
      yank

      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavour 'macchiato'
          set -g @catppuccin_window_status_style 'rounded'
          set -g @catppuccin_window_flags 'icon'
          run-shell "${pkgs.tmuxPlugins.catppuccin}/share/tmux-plugins/catppuccin/catppuccin.tmux"
          set -g status-right-length 200
          set -g status-left-length 100
          set -g status-left ""
          set -g status-right "#{E:@catppuccin_status_application}"
          set -agF status-right "#{E:@catppuccin_status_cpu}"
          set -ag status-right "#{E:@catppuccin_status_session}"
          set -ag status-right "#{E:@catppuccin_status_uptime}"
          # set -agF status-right "#{E:@catppuccin_status_battery}"
        '';
      }
      cpu
      battery
    ];
    extraConfig = ''
      # The border-status is very handy when building large projects (i.e. Gentoo),
      # because tmux will show you where you are along the way
      #set -g pane-border-status top

      # Use Alt-arrow keys without prefix key to switch panes
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D
      
      # Shift arrow to switch windows
      bind -n S-Left  previous-window
      bind -n S-Right next-window
      
      # Shift Alt vim keys to switch windows
      bind -n M-H previous-window
      bind -n M-L next-window

      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
      
      bind '"' split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
    '';
  };

  programs.kitty = {
    enable = true;
    font = {
      name = "NotoSansM Nerd Font Mono";
      size = 12;
    };
  };

  programs.foot = {
    enable = true;
    settings.main.font = "NotoSansM Nerd Font Mono:size=12";
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    icons = "auto";
    git = true;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    configType = "lua";
    systemd.enable = false;
    settings = {
      on = {
        _args = [
          "hyprland.start" (lib.generators.mkLuaInline ''
            function()
              hl.exec_cmd("hyprpaper")
              hl.exec_cmd("waybar")
              hl.exec_cmd("mako")
            end
          '')
        ];
      };
      #general = {
        #gaps_in = 3;
        #gaps_out = 8;
      #};
      bind = [
        {
          _args = [
            "SUPER + Return"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd('kitty')")
          ];
        }
        {
          _args = [
            "SUPER + R"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd('fuzzel')")
          ];
        }
        {
          _args = [
            "SUPER + D"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd('tofi-drun --drun-launch=true')")
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + X"
            (lib.generators.mkLuaInline "hl.dsp.exit()")
          ];
        }
        {
          _args = [
            "SUPER + V"
            (lib.generators.mkLuaInline "hl.dsp.window.float({ action = 'toggle' })")
          ];
        }
        {
          _args = [
            "SUPER + mouse:272"
            (lib.generators.mkLuaInline "hl.dsp.window.drag()")
            { mouse = true; }
          ];
        }
        {
          _args = [
            "SUPER + mouse:273"
            (lib.generators.mkLuaInline "hl.dsp.window.resize()")
            { mouse = true; }
          ];
        }
        {
          _args = [
            "Print"
            (lib.generators.mkLuaInline
              "hl.dsp.exec_cmd('mkdir -p ~/Pictures/screenshots && grim ~/Pictures/screenshots/$(date +%Y%m%d-%H%M%S).png')")
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + S"
            (lib.generators.mkLuaInline
              ''hl.dsp.exec_cmd('mkdir -p ~/Pictures/screenshots && grim -g "$(slurp)" ~/Pictures/screenshots/$(date +%Y%m%d-%H%M%S).png')'')
          ];
        }

#        "mod + Return, exec, kitty"
#        "mod + R, exec, fuzzel"
#        "mod + D, exec, tofi-drun --drun-launch=true"
#        "mod + F, exec, firefox"
#        "mod + X, exec, hyprlock"
#        "mod + SHIFT + X, exit"
#        ",  XF86MonBrightnessUp, exec, brightnessctl set '+5%'"
#        ",  XF86MonBrightnessDown, exec, brightnessctl set '5%-'"
#        ",  XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
#        ",  XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
#        ",  XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
#        "mod CONTROL, XF86TouchpadToggle, exec, toggle-touchpad"
      ];
    };
    extraConfig = ''
      hl.monitor({
        output = "",
        mode = "preferred",
        position = "auto",
        scale = 1
      })
      hl.config({
        general = {
          gaps_in = 3,
          gaps_out = 8
        }
      })
      hl.config({
        input = {
          touchpad = {
            tap_to_click = false
          }
        }
      })
      hl.config({
        decoration = {
          rounding = 8
        }
      })
      hl.window_rule({
        match = { class = "kitty" },
        opacity = "0.75 0.75"
      })
      hl.window_rule({
        match = { class = "foot" },
        opacity = "0.75 0.75"
      })
      hl.window_rule({
        match = { class = "^[Ss]team$" },
        float = true
      })
      hl.window_rule({
        match = { class = "^steam_app_[0-9]+$" },
        float = true
      })
      -- Bitwarden's "unlock vault" prompt opens as a separate Chrome
      -- extension window (class chrome-<extension-id>-Default) rather
      -- than a popup layer, so Hyprland tiles it like a normal window
      -- unless told otherwise.
      hl.window_rule({
        match = { class = "^chrome-nngceckbapebfimnlniiiahkandclblb-Default$" },
        float = true
      })
      -- Proton/Steam games often just resize themselves to the monitor
      -- resolution instead of requesting real compositor fullscreen, so
      -- waybar (a top-layer surface) still draws over the top of them.
      -- Forcing real fullscreen makes Hyprland hide top-layer surfaces
      -- like waybar behind the game as expected.
      -- steam_app_8500 covers EVE Launcher, a titleless Steam helper
      -- window, and the actual EVE game client, so match the game's
      -- exact title rather than fighting the other two with excludes.
      hl.window_rule({
        match = { class = "^steam_app_8500$", title = "^EVE$" },
        fullscreen = true
      })
      -- EVE Launcher itself requests a window the size of the whole
      -- monitor on open, so give it a sane floating size instead.
      -- (window_w/window_h in `move` reflect the pre-rule size, not
      -- the `size` set just above, so use literal offsets here.)
      hl.window_rule({
        match = { class = "^steam_app_8500$", title = "^EVE Launcher$" },
        size = "1600 1000",
        move = "(monitor_w/2)-800 (monitor_h/2)-500"
      })
      -- The negative-title rule above only stops *us* from forcing
      -- fullscreen at window open. EVE Launcher separately asks the
      -- compositor to go fullscreen itself a moment after opening
      -- (that's the delayed "blow up" behavior) -- suppress_event
      -- blocks that self-requested fullscreen event specifically.
      hl.window_rule({
        match = { class = "^steam_app_8500$" },
        suppress_event = "fullscreen"
      })
      for i = 1, 10 do
        local key = i % 10
        hl.bind("SUPER + ".. key, hl.dsp.focus({workspace = i}))
        hl.bind("SUPER + SHIFT + ".. key, hl.dsp.window.move({workspace = i}))
      end
    '';
  };

  programs.waybar = {
    enable = true;
    style = ''
      * {
        font-family: "Noto Sans Nerd Font";
        font-size: 14px;
      }
      window#waybar {
        background: rgba(0, 0, 0, 0.45);
        color: #ffffff;
      }
      #workspaces button {
        color: #888888;
        padding: 0 6px;
      }
      #workspaces button.active {
        color: #ffffff;
        border-bottom: 2px solid #ffffff;
      }
      #network, #battery, #wireplumber {
        padding: 0 10px;
        color: #ffffff;
      }
      #wireplumber.muted {
        color: #6c7086;
      }
      #network.wifi {
        color: #a6e3a1;
      }
      #network.ethernet {
        color: #f9e2af;
      }
      #network.disconnected {
        color: #f38ba8;
      }
      #battery.charging {
        color: #a6e3a1;
      }
      #battery.critical:not(.charging) {
        color: #f38ba8;
      }
    '';
    settings = [{
      layer = "top";
      position = "top";
      modules-left = [ "hyprland/workspaces" ];
      modules-center = [ "custom/clock" ];
      modules-right = [ "tray" "network" "wireplumber" "battery" ];
      "hyprland/workspaces" = {
        format = "{id}";
      };
      "custom/clock" = {
        exec = "date '+%A, %B %d  %-I:%M %p'";
        interval = 10;
        format = "{}";
      };
      network = {
        format-wifi = "{essid} 󰤨";
        format-ethernet = "{ifname} 󰈀";
        format-disconnected = "󰤭";
        tooltip-format-wifi = "{signalStrength}% {frequency}MHz";
      };
      wireplumber = {
        format = "{volume}% {icon}";
        format-muted = "󰝟";
        format-icons = [ "󰕿" "󰖀" "󰕾" ];
      };
      battery = {
        format = "{capacity}% {icon}";
        format-charging = "{capacity}% 󰂄";
        format-icons = [ "󰂎" "󰁺" "󰁽" "󰁿" "󰁹" ];
        states = { critical = 15; };
      };
    }];
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = true;
      };
      background = [{
        monitor = "";
        path = "screenshot";
        blur_passes = 3;
        blur_size = 8;
      }];
      label = [
        {
          monitor = "";
          text = ''cmd[update:1000] date "+%-I:%M %p"'';
          font_size = 96;
          font_family = "NotoSansM Nerd Font Mono";
          position = "0, 100";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = ''cmd[update:60000] date "+%A, %B %d"'';
          font_size = 24;
          font_family = "NotoSansM Nerd Font Mono";
          position = "0, 10";
          halign = "center";
          valign = "center";
        }
      ];
      input-field = [{
        monitor = "";
        size = "300, 50";
        position = "0, -80";
        halign = "center";
        valign = "center";
        dots_center = true;
        fade_on_empty = false;
        placeholder_text = "";
        shadow_passes = 2;
      }];
    };
  };

  services.mako = {
    enable = true;
    settings = {
      background-color = "#000000bb";
      text-color = "#ffffffff";
      border-color = "#ffffffaa";
      border-radius = 8;
      border-size = 2;
      default-timeout = 5000;
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        {
          timeout = 300;
          on-timeout = "brightnessctl -s set 10%";
          on-resume = "brightnessctl -r";
        }
        {
          timeout = 600;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 660;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };

  # The system-level edifier-bluetooth-autoconnect service (configuration.nix)
  # connects the speakers as soon as the bluetooth adapter powers on at boot,
  # which is before wireplumber (and its A2DP media endpoints) exist for this
  # user session -- bluetoothctl connect either fails with "Protocol not
  # available" or completes a bare ACL link that never turns into a working
  # audio stream, which is what shows up as a connect-then-disconnect
  # notification once the desktop appears. Re-run the same retry loop here,
  # scoped to the user session and ordered after wireplumber, so it (re)tries
  # once the A2DP endpoints actually exist -- including after wireplumber
  # restarts, e.g. across a suspend/resume cycle.
  systemd.user.services.edifier-bluetooth-autoconnect = {
    Unit = {
      Description = "Auto-connect Edifier bluetooth speakers (user session)";
      After = [ "wireplumber.service" ];
      PartOf = [ "wireplumber.service" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "edifier-bluetooth-connect-user" ''
        set -eu
        mac=64:68:76:70:F3:FE
        for i in $(seq 1 30); do
          if ${pkgs.bluez}/bin/bluetoothctl info "$mac" | grep -q "Connected: yes"; then
            exit 0
          fi
          ${pkgs.bluez}/bin/bluetoothctl connect "$mac" && exit 0
          sleep 2
        done
        exit 1
      '';
    };
    Install = {
      WantedBy = [ "wireplumber.service" ];
    };
  };

  xdg.configFile."tofi/config".text = ''
    font = Noto Sans Nerd Font
    font-size = 11
    width = 100%
    height = 32
    anchor = top
    margin-top = 0
    padding-left = 8
    padding-right = 8
    padding-top = 4
    padding-bottom = 4
    outline-width = 0
    border-width = 0
    corner-radius = 0
    background-color = #000000bb
    text-color = #ffffffff
    prompt-color = #a6e3a1ff
    selection-color = #ffffffff
    selection-background = #ffffff1a
    result-spacing = 16
    num-results = 8
  '';

  xdg.configFile."fuzzel/fuzzel.ini".text = ''
    [main]
    font=Noto Sans Nerd Font:size=11
    width=40
    lines=8
    border-radius=8
    border-width=3

    [colors]
    background=000000bb
    text=ffffffff
    match=a6e3a1ff
    selection=ffffff1a
    selection-text=ffffffff
    border=ffffffaa
  '';

  # gpg-agent's SSH support (configuration.nix: programs.gnupg.agent.enableSSHSupport)
  # only exports SSH_AUTH_SOCK into interactive shells, not into the graphical
  # session. uwsm sources this file before starting Hyprland and forwards the
  # variable into the systemd/D-Bus activation environment, so every app
  # launched in the session (terminals, launchers, etc.) inherits it.
  xdg.configFile."uwsm/env".text = ''
    export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gnupg/S.gpg-agent.ssh"
  '';

  xdg.configFile."hypr/hyprpaper.conf".text = ''
    splash = false

    wallpaper {
      monitor = DP-1
      path = ${wallpaper}
    }

    wallpaper {
      monitor = HDMI-A-1
      path = ${wallpaper}
    }
  '';

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "google-chrome.desktop";
      "x-scheme-handler/http" = "google-chrome.desktop";
      "x-scheme-handler/https" = "google-chrome.desktop";
      "x-scheme-handler/about" = "google-chrome.desktop";
      "x-scheme-handler/unknown" = "google-chrome.desktop";
    };
  };

  xdg.configFile."nvim" = {
    source = "${inputs.nvim-config}";
    recursive = true;
  };

  # home.file with recursive=true symlinks every file individually (rather than
  # one symlink for the whole tree), including files/share/default_pfx - the
  # template wine-prefix Proton copies per-game. GE-Proton's copy_pfx() preserves
  # symlinks verbatim, so the copied prefix ends up with .update-timestamp/*.reg
  # pointing back into the read-only Nix store, and Proton crashes with EROFS
  # trying to write a fresh timestamp through it. Copy the tree instead so it's
  # real, writable files.
  home.activation.installGEProton = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    geProtonDest="$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton${geProtonVersion}-x86_64"
    if [ ! -e "$geProtonDest/.nix-source" ] || [ "$(cat "$geProtonDest/.nix-source" 2>/dev/null)" != "${geProton}" ]; then
      $DRY_RUN_CMD rm -rf "$geProtonDest"
      $DRY_RUN_CMD mkdir -p "$geProtonDest"
      $DRY_RUN_CMD cp -r --preserve=mode --no-preserve=ownership "${geProton}/." "$geProtonDest/"
      $DRY_RUN_CMD chmod -R u+w "$geProtonDest"
      $DRY_RUN_CMD echo -n "${geProton}" > "$geProtonDest/.nix-source"
    fi
  '';

  home.stateVersion = "25.11";
}

