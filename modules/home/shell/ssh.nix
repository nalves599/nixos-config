{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.shell.ssh;
in {
  options.modules.shell.ssh.enable = mkEnableOption "ssh";

  config = mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      extraConfig = ''
        CanonicalizeHostname yes
        CanonicalDomains rnl.tecnico.ulisboa.pt
        CanonicalizeMaxDots 0
        IdentityFile /persist/secrets/ssh/id_ed25519

        Match canonical host="*.rnl.tecnico.ulisboa.pt"
          User root
          SendEnv RNLADMIN
          ServerAliveInterval 60

        Host *.rnl.tecnico.ulisboa.pt,*.rnl.ist.utl.pt
          User root
          SendEnv RNLADMIN
          ServerAliveInterval 60
      '';
    };
  };
}
