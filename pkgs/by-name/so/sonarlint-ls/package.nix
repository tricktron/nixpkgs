{ lib
, fetchFromGitHub
, makeWrapper
, jre_headless
, maven
, writeScript
}:

maven.buildMavenPackage rec {
  pname = "sonarlint-ls";
  version = "3.5.1.75119";

  src = fetchFromGitHub {
    owner = "SonarSource";
    repo = "sonarlint-language-server";
    rev = version;
    hash = "sha256-6tbuX0wUpqbTyM44e7PqZHL0/XjN8hTFCgfzV+qc1m0=";
  };

  manualMvnArtifacts = [
  ];

  mvnHash = "sha256-LSnClLdAuqSyyT7O4f4aVaPBxdkkZQz60wTmqwQuzdU=";

  buildOffline = true;

  # disable gitcommitid plugin which needs a .git folder which we
  # don't have
  mvnDepsParameters = "-Dskip.installnodenpm=true -Dskip.npm";

  # disable failing tests which either need internet access or are flaky
  mvnParameters = lib.escapeShellArgs [
    "-Dskip.installnodenpm=true"
    "-Dskip.npm"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share
    install -Dm644 target/sonarlint-language-server-*.jar \
      $out/share

    makeWrapper ${jre_headless}/bin/java $out/bin/sonarlint-ls \
      --add-flags "-jar $out/share/sonarlint-language-server-*.jar"

    runHook postInstall
  '';

  nativeBuildInputs = [ makeWrapper ];

  meta = with lib; {
    description = "Sonarlint language server";
    mainProgram = "sonarlint-ls";
    homepage = "https://github.com/SonarSource/sonarlint-language-server";
    license = licenses.epl20;
    maintainers = with maintainers; [ tricktron ];
  };
}

