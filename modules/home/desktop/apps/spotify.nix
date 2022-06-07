{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.desktop.apps.spotify;
in
{
  options.modules.desktop.apps.spotify.enable = mkEnableOption "spotify";

  config = mkIf cfg.enable {
    home.packages = [ pkgs.unstable.spotify ];
  };
}
