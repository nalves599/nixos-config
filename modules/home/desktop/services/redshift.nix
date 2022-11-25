{ lib, config, configDir, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.desktop.services.redshift;
in
{
  options.modules.desktop.services.redshift.enable = mkEnableOption "redshift";

  config = mkIf cfg.enable {
    services.redshift = {
      enable = true;
      latitude = 48.864716;
      longitude = 2.349014;
      temperature = {
        day = 3800;
        night = 3800;
      };
    };
  };
}
