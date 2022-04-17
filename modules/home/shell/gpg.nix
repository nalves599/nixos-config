
{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.shell.gpg;
in {
  options.modules.shell.gpg.enable = mkEnableOption "gpg";

  config = mkIf cfg.enable {
    services.gpg-agent = {
      enable = true;
    };
    programs.gpg = {
      enable = true;
      homedir = "${config.xdg.dataHome}/.gnupg";
    };
  };
}
