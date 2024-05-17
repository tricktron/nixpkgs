{ lib
, fetchFromGitHub
, makeWrapper
, jre_headless
, maven
, writeScript
, jdk17
}:

let mavenJdk17 = maven.override { jdk = jdk17; };

in

mavenJdk17.buildMavenPackage rec {
  pname = "sonarlint-ls";
  version = "3.5.1.75119";

  src = fetchFromGitHub {
    owner = "SonarSource";
    repo = "sonarlint-language-server";
    rev = version;
    hash = "sha256-6tbuX0wUpqbTyM44e7PqZHL0/XjN8hTFCgfzV+qc1m0=";
  };

  manualMvnArtifacts = [
    "org.apache.maven.surefire:surefire-junit-platform:3.1.2"
    "org.junit.platform:junit-platform-launcher:1.8.2"
  ];

  mvnHash = "sha256-ZhAQtpi0wQP8+QPeYaor2MveY+DZ9RPENb3kITnuWd8=";

  buildOffline = true;

  # disable gitcommitid plugin which needs a .git folder which we
  # don't have
  mvnDepsParameters = "-Dskip.installnodenpm=true -Dskip.npm -DskipTests package";

  # disable failing tests which either need internet access or are flaky
  mvnParameters = lib.escapeShellArgs [
    "-Dskip.installnodenpm=true"
    "-Dskip.npm"
    "-Dtest=!LanguageServerMediumTests,
    !LanguageServerWithFoldersMediumTests,
    !NotebookMediumTests,
    !ConnectedModeMediumTests,
    !JavaMediumTests"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share $out/share/plugins
    install -Dm644 target/sonarlint-language-server-*.jar \
      $out/share/sonarlint-ls.jar
    install -Dm644 target/plugins/* \
      $out/share/plugins


    makeWrapper ${jre_headless}/bin/java $out/bin/sonarlint-ls \
      --add-flags "-jar $out/share/sonarlint-ls.jar" \
      --add-flags "-stdio" \
      --add-flags "-analyzers $(ls -1 $out/share/plugins | tr '\n' ' ')"

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

