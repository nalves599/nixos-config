{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.desktop.gtk;
in
{
  options.modules.desktop.gtk.enable = mkEnableOption "gtk";

  config = mkIf cfg.enable {
    gtk.enable = true;
    gtk.gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
  };
}