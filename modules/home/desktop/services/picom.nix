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
      blur = true;
      fade = false;
      inactiveDim = "0.2";
      vSync = true;
    };
  };
}
