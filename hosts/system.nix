{ inputs, pkgs, lib, ... }:
let
  inherit (builtins) toString;
in {
  nix.package = pkgs.nixUnstable;
  nix.extraOptions = "experimental-features = nix-command flakes";

  # Every host shares the same time zone.
  time.timeZone = "Europe/Lisbon";

  # Essential packages.
  environment.systemPackages = with pkgs; [
    bashmount
    curl
    dig
    fd
    file
    gcc
    git
    gnumake
    htop
    man-pages
    neofetch
    netcat-gnu
    python39
    ripgrep
    unzip
    vim
    wget
    xdotool
    zip
  ];

  system.stateVersion = "22.05";
}
