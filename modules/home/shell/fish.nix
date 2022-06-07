{ pkgs, config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.shell.fish;
in
{
  options.modules.shell.fish.enable = mkEnableOption "fish";

  config = mkIf cfg.enable {
    programs.fish = {
      enable = true;
      interactiveShellInit = "any-nix-shell fish --info-right | source";
      functions = {
      };
      shellAliases = {
        ssh = "TERM=xterm-256color /usr/bin/env ssh";
      };
      shellAbbrs = {
        xopen = "xdg-open";
        cd = "z";
        n = mkIf config.modules.shell.neovim.enable "nvim";
        nv = mkIf config.modules.shell.neovim.enable "nvim";
        g = mkIf config.modules.shell.git.enable "git";
        rebuild = "sudo nixos-rebuild switch --flake /etc/dotfiles";
      };
    };

    # zoxide
    programs.zoxide.enable = true;
    home.sessionVariables._ZO_ECHO = "1";

    programs.starship = {
      enable = true;
      package = pkgs.unstable.starship;
      enableFishIntegration = true;
      settings = {
        add_newline = false;
        scan_timeout = 1;
        line_break.disabled = true;
        hostname.format = "🐧 ";
        username.disabled = true;
        localip.disabled = true;
      };
    };
  };
}
