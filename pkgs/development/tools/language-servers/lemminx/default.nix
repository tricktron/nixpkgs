{
  lib, fetchFromGitHub, makeWrapper, jre, maven
}:

maven.buildMavenPackage rec {
  pname = "lemminx";
  version = "d1d67ec09ad8ded638fc7c8ce1f52b72b33b8ec9";

  src = fetchFromGitHub {
    owner = "eclipse";
    repo = "lemminx";
    rev = version;
    hash = "sha256-rRttA5H0A0c44loBzbKH7Waoted3IsOgxGCD2VM0U/Q=";
  };

  mvnHash = "sha256-rRttA5H0A0c44loBzbKH7Waoted3IsOgxGCD2VM0U/Q=";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    ls $out
    cp -r org.eclipse.lemminx/target/* $out

    makeWrapper ${jre}/bin/java $out/bin/lemminx \
      --add-flags "-cp $out/org.eclipse.lemminx-uber.jar org.eclipse.lemminx.XMLServerSocketLauncher"

    runHook postInstall
  '';

  nativeBuildInputs = [ makeWrapper ];

  meta = with lib; {
    description = "XML Language Server";
    homepage = "https://github.com/eclipse/lemminx";
    license = licenses.epl20;
    maintainers = with maintainers; [ tricktron ];
  };
}
