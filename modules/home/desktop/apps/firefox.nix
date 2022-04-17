{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.desktop.apps.firefox;
in {
  options.modules.desktop.apps.firefox.enable = mkEnableOption "firefox";

  config = mkIf cfg.enable {
    programs.firefox.enable = true;
  };
}