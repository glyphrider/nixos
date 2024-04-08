{ config, pkgs, inputs, ... }:
{
  wayland.windowManager.hyprland.settings.bind = [
    "$mod, R, exec, ${pkgs.wofi}/bin/wofi --show drun"
  ];
  programs.wofi = {
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
}
