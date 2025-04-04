{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ut";
  version = "2.3.0";

  cmakeFlags = [
    "-DBOOST_UT_ALLOW_CPM_USE=OFF"
  ];

  src = fetchFromGitHub {
    owner = "boost-ext";
    repo = "ut";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3H3kyf58gy+VdNfj4gmIe+D1+douMwZQU7+iphO+utU=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  meta = with lib; {
    description = "UT: C++20 μ(micro)/Unit Testing Framework";
    homepage = "https://github.com/boost-ext/ut";
    license = licenses.boost;
    maintainers = with maintainers; [ matthewcroughan ];
    platforms = platforms.all;
  };
})
