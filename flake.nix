{
  description = "Nix configuration for a RNL SysAdmin";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    impermanence.url = "github:nix-community/impermanence/master";
    home = {
      url = "github:nix-community/home-manager/release-21.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, ... }:
    let
      inherit (builtins) attrNames attrValues concatLists readDir;
      inherit (inputs.nixpkgs) lib;
      inherit (lib) listToAttrs removeSuffix hasSuffix mapAttrs;

      system = "x86_64-linux";
      user = "nalves599";

      mkPkgs = pkgs: extraOverlays: import pkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = extraOverlays ++ (attrValues self.overlays);
      };

      pkgs = mkPkgs inputs.nixpkgs [ self.overlay ];
      pkgs' = mkPkgs inputs.nixpkgs-unstable [];

      # Read directory and import every nix module, recursively
      mkModules = dir: concatLists (attrValues (mapAttrs
        (name: value:
          if value == "directory"
          then mkModules "${dir}/${name}"
          else if value == "regular" && hasSuffix ".nix" name
          then [ (import "${dir}/${name}") ]
          else [])
        (readDir dir)));

      systemModules = mkModules ./modules/system;
      homeModules = mkModules ./modules/home;

      mkOverlays = dir: listToAttrs (map
        (name: {
            name = removeSuffix ".nix" name;
            value = import "${dir}/${name}" {
              packageDir = "./packages";
            };
        })
        (attrNames (readDir dir)));

      mkHosts = dir: listToAttrs (map (
        name: {
          inherit name;
          value = inputs.nixpkgs.lib.nixosSystem {
            inherit system pkgs;
            specialArgs = { inherit user; configDir = ./config; };
            modules = [
              { networking.hostName = name; }
              ( import "${dir}/system.nix" )
              ( import "${dir}/${name}/system.nix" )
              ( import "${dir}/${name}/hardware.nix" )
              inputs.home.nixosModules.home-manager {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  extraSpecialArgs.configDir = ./config;
                  sharedModules = [ (import "${dir}/home.nix") ] ++ homeModules;
                  users.${user} = import "${dir}/${name}/home.nix";
                };
              }
            ] ++ systemModules;
          };
        }) (attrNames (removeAttrs (readDir dir) [ "system.nix" "home.nix" ])));

    in {
      overlay = final: prev: {
        unstable = pkgs';
      };

      overlays = mkOverlays ./overlays;

      nixosConfigurations = mkHosts ./hosts;
    };
}
