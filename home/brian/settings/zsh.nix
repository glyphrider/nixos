{ config, pkgs, inputs, ... }:
{
  programs.zsh = {
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
    sessionVariables = {
      GSETTIGNS_BACKEND = "keyfile";
    };
  };
  home.file.".p10k.zsh".source = ./p10k-default.zsh;
}
