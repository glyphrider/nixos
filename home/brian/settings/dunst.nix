{ config, pkgs, inputs, ... }:
{
  home.packages = [
    pkgs.tela-circle-icon-theme
  ];
  
  services.dunst = {
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
}