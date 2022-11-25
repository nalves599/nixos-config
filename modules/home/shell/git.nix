{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.shell.git;
in {
  options.modules.shell.git.enable = mkEnableOption "git";

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = "Nuno Alves";
      userEmail = "nuno.alves02@gmail.com";
      signing = {
        key = null; # Let GnuPG decide which signing key to use depending on commit's author
        signByDefault = true;
      };
      extraConfig = {
        init.defaultBranch = "main";
        url."git@github.com".pushinsteadOf = "https://github.com/";
      };
      aliases = {
        st = "status -sb";
        lg = "log --pretty=format:'%Cred%h%Creset %C(bold)%cr%Creset %Cgreen<%an>%Creset %s' --max-count=30";
      };
      includes = [
        {
          condition = "gitdir:~/Documents/RNL/";
          contents = {
            user.email = "nuno.alves@rnl.tecnico.ulisboa.pt";
          };
        }
      ];
    };
  };
}
