{ pkgs, config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.shell.tmux;
in
{
  options.modules.shell.tmux.enable = mkEnableOption "tmux";

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      escapeTime = 10;
      extraConfig = ''
        set-option -g mouse

        # Split panes
        bind , split-window -v
        bind . split-window -h
      '';
    };
  };
}
