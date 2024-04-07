{ config, pkgs, inputs, ... }:
{
  home.file.".emacs".text = ''
    (setq erlang-root-dir "${pkgs.erlang}/lib/erlang/")
    (setq erlang-lib-dir (concat erlang-root-dir "lib/"))
    (setq erlang-bin-dir (concat erlang-root-dir "bin/"))
    (setq erlang-tools (car (directory-files erlang-lib-dir nil "^tools-.*")))
    (setq erlang-mode-dir (concat erlang-lib-dir erlang-tools "/emacs"))
    (setq load-path (cons erlang-mode-dir load-path))
    (setq exec-path (cons erlang-bin-dir exec-path))
    (require 'erlang-start)
  '';
}
