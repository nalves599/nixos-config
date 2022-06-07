{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.wireguard;
in {
  options.modules.wireguard.enable = mkEnableOption "wireguard";

  config = mkIf cfg.enable {
    networking.wg-quick.interfaces = {
      wgrnl = {
        address = [ "192.168.20.43/24" "fd92:3315:9e43:c490::43/64" ];
        dns = [ "193.136.164.1" "193.136.164.2" ];
        privateKeyFile = "/persist/secrets/wireguard/wg-privkey";
        table = "765";
        postUp = ''
          ${pkgs.wireguard-tools}/bin/wg set wgrnl fwmark 765
          ${pkgs.iproute2}/bin/ip rule add not fwmark 765 table 765
          ${pkgs.iproute2}/bin/ip -6 rule add not fwmark 765 table 765
        '';
        postDown = ''
          ${pkgs.iproute2}/bin/ip rule del not fwmark 765 table 765
          ${pkgs.iproute2}/bin/ip -6 rule del not fwmark 765 table 765
        '';
        peers = [
          {
            publicKey = "g08PXxMmzC6HA+Jxd+hJU0zJdI6BaQJZMgUrv2FdLBY=";
            endpoint = "193.136.164.211:34266";
            allowedIPs = [ "193.136.164.0/24" "193.136.154.0/24" "10.16.64.0/18" "2001:690:2100:80::/58" "192.168.154.0/24" ];
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };
}
