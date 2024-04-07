{ config, pkgs, inputs, ... }:
{
  programs.vim = {
    settings = {
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      number = true;
      relativenumber = true;
    };
  };
}