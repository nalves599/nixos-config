{ lib, config, configDir, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.desktop.services.wallpaper;
in
{
  options.modules.desktop.services.wallpaper.enable = mkEnableOption "wallpaper";

  config = mkIf cfg.enable {
    programs.feh.enable = true;
    services.random-background = {
      enable = true;
      imageDirectory = "${configDir}/wallpapers";
    };
  };
}
