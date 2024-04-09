{ config, pkgs, inputs, ... }:
{
  home.packages = [ pkgs.erlang pkgs.rebar3 ];
}
