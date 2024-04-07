{ config, pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    awscli2
    bitwarden
    cmatrix
    cowsay
    discord
    erlang
    ffmpeg
    firefox
    fortune
    gimp
    gnome3.adwaita-icon-theme
    google-chrome
    grim
    htop
    lollypop
    lutris
    neofetch
    obs-studio
    pavucontrol # pipewire -> pulseaudio
    rebar3 # build tool for erlang; needed for erlang-ls in neovim
    rustup # used to install a version of rust
    slurp
    steam
    swappy
    unzip # needed for the elixir-ls in neovim
    vscode
    wineWowPackages.stable # both 64-bit and 32-bit wine(s)
    wireshark # wireshark seems to need both the package *and* the programs.wireshark.enable = true
    wl-clipboard
    xdg-user-dirs
  ];
}
