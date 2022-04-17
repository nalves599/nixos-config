{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.desktop.apps.discord;
in
{
  options.modules.desktop.apps.discord.enable = mkEnableOption "discord";

  config = mkIf cfg.enable {
    home.packages = [ pkgs.unstable.discord ];
  };
}
