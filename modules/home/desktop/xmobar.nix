{ lib, config, pkgs, configDir, ... }:
let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.modules.desktop.xmobar;
in {
  options.modules.desktop.xmobar = {
    enable = mkEnableOption "xmobar";
    type = mkOption {
      type = types.enum [ "laptop" "desktop" ];
    };
  };
  
  config = mkIf cfg.enable {
    home = {
      packages = [ pkgs.haskellPackages.xmobar pkgs.pamixer ];
      file.".xmonad/xmobar.hs".source = "${configDir}/xmobar/${cfg.type}.hs";
    };
  };
}
