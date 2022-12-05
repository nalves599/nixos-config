{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.desktop.services.picom;
in
{
  options.modules.desktop.services.picom.enable = mkEnableOption "picom";

  config = mkIf cfg.enable {
    services.picom = {
      enable = true;
      vSync = true;
    };
  };
}
