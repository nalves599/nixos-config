{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.desktop.apps.rofi;
in
{
  options.modules.desktop.apps.rofi.enable = mkEnableOption "rofi";

  config = mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      theme = "gruvbox-dark";
      plugins = [ pkgs.rofi-calc pkgs.rofi-emoji ];
    };
  };
}
