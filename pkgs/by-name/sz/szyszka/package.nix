{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  glib,
  cairo,
  pango,
  atk,
  gdk-pixbuf,
  gtk4,
  wrapGAppsHook4,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "szyszka";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "qarmin";
    repo = "szyszka";
    tag = version;
    hash = "sha256-LkXGKDFKaY+mg53ZEO4h2br/4eRle/QbSQJTVEMpAoY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-0VlhBd1GpmynNflssizg+Y9D8Hr40rT7OzOSP4AmhxY=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs =
    [
      glib
      cairo
      pango
      atk
      gdk-pixbuf
      gtk4
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        Foundation
      ]
    );

  postInstall = ''
    install -m 444 \
        -D data/com.github.qarmin.szyszka.desktop \
        -t $out/share/applications
    install -m 444 \
        -D data/com.github.qarmin.szyszka.metainfo.xml \
        -t $out/share/metainfo
    install -m 444 \
        -D data/icons/com.github.qarmin.szyszka.svg \
        -t $out/share/icons/hicolor/scalable/apps
  '';

  meta = with lib; {
    description = "Simple but powerful and fast bulk file renamer";
    homepage = "https://github.com/qarmin/szyszka";
    license = licenses.mit;
    maintainers = with maintainers; [ kranzes ];
    mainProgram = "szyszka";
  };
}
