{ packageDir, ... }: final: prev: rec {
  chef-workstation = prev.callPackage "${packageDir}/chef-workstation" {};
}
