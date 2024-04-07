{ config, pkgs, inputs, ... }:
{
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
    slurp
    steam
    swappy
    swww
    unzip # needed for the elixir-ls in neovim
    vscode
    waybar
    wineWowPackages.stable # both 64-bit and 32-bit wine(s)
    wireshark # wireshark seems to need both the package *and* the programs.wireshark.enable = true
    wl-clipboard
    xdg-user-dirs
  ];
}