{ config, pkgs, inputs, ... }:
{
  programs.waybar = {
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
}