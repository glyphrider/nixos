{ config, pkgs, inputs, ... }:
{
  programs.git = {
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
}