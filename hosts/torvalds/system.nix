{ config, pkgs, options, lib, ... }:
{
  # Modules configuration.
  modules = {
    desktop = {
      slock.enable = true;
      fonts.enable = true;
    };
  };

  # Extra packages.
  environment.systemPackages = [
    pkgs.pipewire
  ];

  environment.sessionVariables = {
    "RNLADMIN" = "nuno.alves";
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    systemd-boot.editor = false;
    efi.canTouchEfiVariables = true;
  };

  services.avahi.enable = true;

  # Define hostname and enable network manager
  networking = {
    hostId = "bb03198b";
    domain = "rnl.tecnico.ulisboa.pt";
    firewall.enable = false;
    wireless.enable = false;
    nameservers = [
      "193.136.164.1"
      "193.136.164.2"
      "2001:690:2100:82::1"
      "2001:690:2100:82::2"
    ];
    search = [ "rnl.tecnico.ulisboa.pt" ];
    interfaces.enp4s0 = {
      ipv4 = {
        addresses = [
          {
            address = "193.136.164.212";
            prefixLength = 27;
          }
        ];
        routes = [
          {
            address = "0.0.0.0";
            prefixLength = 0;
            via = "193.136.164.222";
          }
        ];
      };
      ipv6 = {
        addresses = [
          {
            address = "2001:690:2100:82::212";
            prefixLength = 64;
          }
        ];
        routes = [
          {
            address = "::";
            prefixLength = 0;
            via = "2001:690:2100:82::ffff:1";
          }
        ];
      };
    };
  };

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "no";
    authorizedKeysFiles = lib.mkForce [ "/etc/ssh/authorized_keys.d/%u" ];
    challengeResponseAuthentication = false;
  };

  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    displayManager.startx.enable = true;
    dpi = 96;
  };

  services.printing.enable = true;

  sound.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  security.rtkit.enable = true;

  hardware = {
    opengl.enable = true;
  };

  nix.trustedUsers = [ "root" "@wheel" ];
  users = {
    mutableUsers = true;
    users.root.initialPassword = "123";
    users.nalves599 = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBN1G9PeJIPuyl4amUH7NovvQRBBKvKAO6ldjr6a0a0K"
	      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEFsP0t1WPaM3G/mdyclf0Fh+4FLuXtuA5NUaF4BLpLk"
      ];
      isNormalUser = true;
      createHome = true;
      shell = pkgs.fish;
      extraGroups = [ "wheel" "video" "libvirtd" ];
    };
  };

  # Required for gtk.
  services.dbus.packages = [ pkgs.gnome3.dconf ];

  security.pki.certificateFiles = let
    cert = pkgs.fetchurl {
      url = "https://rnl.tecnico.ulisboa.pt/ca/cacert/cacert.pem";
      hash = "sha256-Qg7e7LIdFXvyh8dbEKLKdyRTwFaKSG0qoNN4KveyGwg=";
    };
  in [ "${cert}" ];
}
