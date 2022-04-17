{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.sxhkd;
in {
  options.modules.sxhkd.enable = mkEnableOption "sxhkd";

  config = mkIf cfg.enable {
    services.sxhkd = {
      enable = true;
      keybindings = {
        "super + p" = "rofi -modi drun -show-icons -show drun";
        "meta + e" = "rofi -modi emoji -show emoji";
        "meta + space" = "rofi -modi calc -show calc";
        "Print" = "flameshot gui";
      };
    };
  };
}
