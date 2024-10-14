{ stdenv, lib, fetchFromGitHub
, rustc, cargo, perl, jq, pkg-config, openconnect, libiconv, glib, atkmm, gtk3, openssl, libsoup, cargo-tauri, darwin
}:

let inherit (darwin.apple_sdk.frameworks)CoreServices Security SystemConfiguration;
in
stdenv.mkDerivation(finalAttrs: {
  pname = "globalprotect-openconnect";
  version = "2.3.7";

  src = fetchFromGitHub {
      owner = "yuezk";
      repo = "GlobalProtect-openconnect";
      rev = "v${finalAttrs.version}";
      hash = "sha256-Zr888II65bUjrbStZfD0AYCXKY6VdKVJHQhbKwaY3is=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ rustc cargo perl jq openconnect libiconv glib atkmm gtk3 openssl libsoup cargo-tauri ]
  ++ lib.optionals stdenv.isDarwin [
      CoreServices
      Security
      SystemConfiguration
  ];

  #buildPhase = ''
  #  make build BUILD_FE=0
  #'';

  buildFlags = [ "build-rs" ];

  #patchPhase = ''
  #  substituteInPlace GPService/gpservice.h \
  #    --replace /usr/local/bin/openconnect ${openconnect}/bin/openconnect;
  #  substituteInPlace GPService/CMakeLists.txt \
  #    --replace /etc/gpservice $out/etc/gpservice;
  #'';

  meta = with lib; {
    description = "GlobalProtect VPN client (GUI) for Linux based on OpenConnect that supports SAML auth mode";
    homepage = "https://github.com/yuezk/GlobalProtect-openconnect";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.jerith666 ];
  };
})
