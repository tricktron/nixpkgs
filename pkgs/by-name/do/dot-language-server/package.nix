{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "dot-language-server";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "nikeee";
    repo = "dot-language-server";
    tag = "v${version}";
    hash = "sha256-NGkobMZrvWlW/jteFowZgGUVQiNm3bS5gv5tN2485VA=";
  };

  npmDepsHash = "sha256-spskj0vqfR9GoQeKyfLsQgRp6JasZeVLCVBt6wZiSP8=";

  npmBuildScript = "compile";

  meta = with lib; {
    description = "Language server for the DOT language";
    mainProgram = "dot-language-server";
    homepage = "https://github.com/nikeee/dot-language-server";
    license = licenses.mit;
    maintainers = [ ];
  };
}
