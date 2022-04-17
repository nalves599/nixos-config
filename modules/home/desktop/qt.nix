{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.desktop.qt;
in
{
  options.modules.desktop.qt.enable = mkEnableOption "qt";

  config = mkIf cfg.enable {
    qt = {
      enable = true;
      platformTheme = "gtk";
    };
  };
}