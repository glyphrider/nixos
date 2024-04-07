{ config, pkgs, inputs, ... }:
{
  home.file.".newsboat/urls".source = ./newsboat-urls;
}
