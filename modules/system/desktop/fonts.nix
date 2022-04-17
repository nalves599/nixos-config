{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.desktop.fonts;
in {
  options.modules.desktop.fonts.enable = mkEnableOption "fonts";

  config = mkIf cfg.enable {
    fonts = {
      enableDefaultFonts = true;
      fonts = with pkgs; [
        noto-fonts 
        noto-fonts-cjk
        jetbrains-mono
        font-awesome
      ];

      fontconfig.defaultFonts = {
        serif = [ "Noto Serif" "Noto Sans CJK JP" ];
        sansSerif = [ "Noto Sans Serif" "Noto Sans CJK JP" ];
        monospace = [ "JetBrains Mono" "Noto Sans Mono" "Noto Sans Mono CJK JP" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}