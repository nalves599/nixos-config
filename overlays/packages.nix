{ packageDir, ... }: self: super: rec {
  discord = super.discord.override {
    nss = self.nss_latest; # Fix discord links using firefox
  };
}
