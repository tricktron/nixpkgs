{ lib
, fetchFromGitHub
, jre_headless
, maven
, jdk17
, makeWrapper
, writeScript
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


  # disable node and npm module installation because the need network access
  # for the tests.
  mvnDepsParameters = "-Dskip.installnodenpm=true -Dskip.npm -DskipTests package";

  # disable failing tests which either need network access or are flaky
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

  passthru.updateScript =
    let pkgFile = builtins.toString ./package.nix;
    in
    writeScript "update-${pname}" ''
        #!/usr/bin/env nix-shell
        #!nix-shell -i bash -p curl pcre common-updater-scripts jq gnused
        set -eu -o pipefail

        LATEST_TAG=$(curl https://api.github.com/repos/${src.owner}/${src.repo}/tags | \
          jq -r '[.[] | select(.name | test("^[0-9]"))] | sort_by(.name | split(".") |
          map(tonumber)) | reverse | .[0].name')
        update-source-version ${pname} "$LATEST_TAG"
        sed -i '0,/mvnHash *= *"[^"]*"/{s/mvnHash = "[^"]*"/mvnHash = ""/}' ${pkgFile}

        echo -e "\nFetching all mvn dependencies to calculate the mvnHash. This may take a while ..."
        nix-build -A ${pname}.fetchedMavenDeps 2> ${pname}-stderr.log || true

        NEW_MVN_HASH=$(cat ${pname}-stderr.log | grep "got:" | awk '{print ''$2}')
        rm ${pname}-stderr.log
        # escaping double quotes looks ugly but is needed for variable substitution
        # use # instead of / as separator because the sha256 might contain the / character
        sed -i "0,/mvnHash *= *\"[^\"]*\"/{s#mvnHash = \"[^\"]*\"#mvnHash = \"$NEW_MVN_HASH\"#}" ${pkgFile}
      '';

  meta = with lib; {
    description = "Sonarlint language server";
    mainProgram = "sonarlint-ls";
    homepage = "https://github.com/SonarSource/sonarlint-language-server";
    license = licenses.epl20;
    maintainers = with maintainers; [ tricktron ];
  };
}

