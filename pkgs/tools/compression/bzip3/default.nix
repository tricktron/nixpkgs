{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bzip3";
  version = "1.5.1";

  outputs = [
    "bin"
    "dev"
    "out"
  ];

  src = fetchFromGitHub {
    owner = "kspalaiologos";
    repo = "bzip3";
    tag = finalAttrs.version;
    hash = "sha256-QMvK0MP0Zx2mQfvYvrOjGV1Lo/ObO5diXcibmwtQATk=";
  };

  postPatch = ''
    echo -n "${finalAttrs.version}" > .tarball-version
    patchShebangs build-aux

    # build-aux/ax_subst_man_date.m4 calls git if the file exists
    rm .gitignore
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  configureFlags = [
    "--disable-arch-native"
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ "--disable-link-time-optimization" ];

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = {
    description = "Better and stronger spiritual successor to BZip2";
    homepage = "https://github.com/kspalaiologos/bzip3";
    changelog = "https://github.com/kspalaiologos/bzip3/blob/${finalAttrs.src.rev}/NEWS";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
    pkgConfigModules = [ "bzip3" ];
    platforms = lib.platforms.unix;
  };
})
