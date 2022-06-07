{ pkgs, ... }:
{
  # Modules configuration.
  modules = {
    xdg.enable = true;
    sxhkd.enable = true;

    shell = {
      git.enable = true;
      gpg.enable = true;
      neovim.enable = true;
      ssh.enable = true;
      tmux.enable = true;
      fish.enable = true;
    };

    desktop = {
      xmonad.enable = true;
      xmobar = {
        enable = true;
        type = "desktop";
      };

      gtk.enable = true;
      qt.enable = true;

      services = {
        picom.enable = true;
        wallpaper.enable = true;
        flameshot.enable = true;
        redshift.enable = true;
      };

      apps = {
        alacritty.enable = true;
        rofi.enable = true;
        dunst.enable = true;
        discord.enable = true;
        firefox.enable = true;
        spotify.enable = true;
      };
    };
  };

  # Extra packages.
  home.packages = with pkgs; [
    mattermost-desktop
    remmina
    virt-manager
    thunderbird-bin
    any-nix-shell
    ansible
    xclip
    libreoffice
    realvnc-vnc-viewer
    zathura
  ];

  home.file.".xinitrc".text = ''
    flameshot &
    exec xmonad
  '';

}
