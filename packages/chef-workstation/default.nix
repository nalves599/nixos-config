{ stdenv, lib, dpkg, fetchurl }:

let
  url = "https://packages.chef.io/files/stable";
in
stdenv.mkDerivation rec {
  name = "chef-workstation";
  version = "21.12.720";

  src = fetchurl {
    url = "${url}/${name}/${version}/ubuntu/20.04/${name}_${version}-1_amd64.deb";
    sha256 = "b7a87814e582633f7dfeea15c968b4b6035f0fc006ae2a816b8e9986b57bdf53";
  };

  unpackCmd = "${dpkg}/bin/dpkg-deb -x $curSrc .";
  installPhase = ''
    mkdir -p $out
    cp -r ./chef-workstation/* $out/
  '';

  fixupPhase = ''
        for binary in \
          berks chef-apply chef-cli chef-client chef-resource-inspector chef-run \
          chef-service-manager chef-shell chef-solo chef-vault \
          chef-windows-service chef-zero cookstyle fauxhai foodcritic inspec \
          kitchen knife mixlib-install ohai stove
        do
          substituteInPlace $out/bin/$binary --replace "#!/opt/chef-workstation/" "#!$out/"
        done

        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$out/bin/delivery"
        for executable in \
          toe fips_standalone_sha1 ruby tabs \
          stunnel openssl infocmp tput clear xmlwf \
          pcretest tic curl pcregrep tset
        do
          patchelf --set-rpath "$out/embedded/lib" "$out/embedded/bin/$executable"
          patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
            "$out/embedded/bin/$executable"
        done

        for library in \
          libarchive.so libcrypto.so libcurl.so libcurses.so libedit.so libexpat.so \
          libexslt.so libffi.so libform.so libformw.so libiconv.so liblzma.so libmenu.so \
          libmenuw.so libncurses.so libncursesw.so libpanel.so libpanelw.so libpcreposix.so \
          libpcre.so libruby.so libssl.so libtinfo.so libtinfow.so libxml2.so libxslt.so \
          libyaml.so libz.so
        do
          patchelf --set-rpath "$out/embedded/lib" "$out/embedded/lib/$library"
        done

        # TODO: Patch /embedded/bin binaries
        # TODO: Patch ruby GEM_PATH and GEM_HOME
  '';

  meta = {
    description = "Chef's developer toolkit that includes Infra, InSpec, Habitat, and tools like knife.";
    homepage = "https://www.chef.io/downloads/tools/workstation";
    license = lib.licenses.gpl3; # This isn't true but I don't know what to put here
    platforms = lib.platforms.linux;
  };
}
