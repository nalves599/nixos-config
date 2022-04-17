{ lib, config, configDir, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.desktop.services.flameshot;
in
{
  options.modules.desktop.services.flameshot.enable = mkEnableOption "flameshot";

  config = mkIf cfg.enable {
    services.flameshot.enable = true;
  };
}