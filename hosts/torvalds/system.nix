{ config, pkgs, options, lib, ... }:
{
  # Modules configuration.
  modules = {
    desktop = {
      slock = {
        enable = true;
        autolock.enable = true;
      };
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

  services.avahi = {
    enable = true;
    publish.enable = true;
  };

  programs.steam.enable = true;

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
    interfaces.enp8s0.useDHCP = false;
    vlans.management = { id = 1; interface = "enp4s0"; };
    interfaces.management.ipv4.addresses = [{
      address = "192.168.102.212";
      prefixLength = 22;
    }];
    #wg-quick.interfaces = {
      #wgstt = {
        #address = [ "10.6.77.137/32" "fd00:677::137/128"];
        #privateKeyFile = "/persist/secrets/wg/privkey";
        #dns = [ "10.5.77.1" ];
        #peers = [
          #{
            #publicKey = "u0DdfahuhX8GsVaQ4P2kBcHoF9kw9HZL9uqPcu2UMw8=";
            #endpoint = "pest.stt.rnl.tecnico.ulisboa.pt:34266";
            #allowedIPs = [
              #"10.0.0.0/8"
              #"fd00::/8"
            #];
            #persistentKeepalive = 25;
          #}
        #];
      #};
    #};
    interfaces.enp4s0 = {
      wakeOnLan.enable = true;
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
    kbdInteractiveAuthentication = false;
  };

  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    displayManager.startx.enable = true;
    dpi = 86;
    xkbOptions = "ctrl:nocaps";
  };

  # Use old version of Nvidia driver to support RNL GPU
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_470;

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

  nix.settings.trusted-users = [ "root" "@wheel" ];
  users = {
    mutableUsers = false;
    users.root.initialHashedPassword = "$6$XIZApqhPtukt/apQ$/lFWBen7ymEAqNybzrz5kwupvEdju4tkdWg5aLOlLv1ADm/RsSzzL3b2cfJvuKT09AF4cisg.VQ0mXgTnQs8Y.";
    users.nalves599 = {
      initialHashedPassword = "$6$lDna6MmmAsbNAFfg$UVNavktffwv8kj72HepUNIOeKZo6idV2s3hIhgCZ2ZFcuNypPkfOeY1kIOpnVN7OR5MLyJsuUBSPhqQT0YQJQ0";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBN1G9PeJIPuyl4amUH7NovvQRBBKvKAO6ldjr6a0a0K @musk"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP8jGGPVwXQBjOUpNYygQhAmjq+3OHp85ckO0PlcmJ4J @jobs"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKCwSZftiPE9cgigiF6KFiizcTZd4sjVi14CcSYi+zfV @bezos"
      ];
      isNormalUser = true;
      createHome = true;
      shell = pkgs.fish;
      extraGroups = [ "wheel" "video" "libvirtd" ];
    };
  };

  # Required for gtk.
  services.dbus.packages = [ pkgs.dconf ];

  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
  };

  security.pki.certificateFiles = let
    cert = pkgs.fetchurl {
      url = "https://rnl.tecnico.ulisboa.pt/ca/cacert/cacert.pem";
      hash = "sha256-Qg7e7LIdFXvyh8dbEKLKdyRTwFaKSG0qoNN4KveyGwg=";
    };
  in [ "${cert}" ];
}
