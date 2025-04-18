{
  mkDerivation,
  lib,
  fetchFromGitLab,
  qtbase,
  cmake,
  ninja,
  libcprime,
  libcsys,
}:

mkDerivation rec {
  pname = "corefm";
  version = "4.5.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-mCFFT/vHzfC4jl1I8SkgaX8qu+AFNNcwUZx4eJeE+i4=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    qtbase
    libcprime
    libcsys
  ];

  meta = with lib; {
    description = "Lightwight filemanager from the C Suite";
    mainProgram = "corefm";
    homepage = "https://gitlab.com/cubocore/coreapps/corefm";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}
