{ buildGoModule, fetchFromGitHub, lib, stdenv, installShellFiles }:

buildGoModule rec {
  pname = "testkube";
  version = "1.10.40";

  src = fetchFromGitHub {
    owner = "kubeshop";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-6U9tbn1hp4OEI5ZNcknXBm64nJtZtC9nuIpsHSl1rQw=";
    # We need the git revision
    leaveDotGit = true;
    postFetch = ''
      git -C $out rev-parse --short HEAD > $out/.git-revision
      rm -rf $out/.git
    '';
  };

  nativeBuildInputs = [ installShellFiles ];

  vendorSha256 = "sha256-DLh4uKT4/YbA0ZjEZXmryyB5BnlL2XD+8JvHy+Su6pM=";

  subPackages = [ "cmd/kubectl-testkube/main.go" ];

  preConfigure = ''
    ldflags="-s -w -X main.version=${version} \
    -X main.commit="$(cat .git-revision)" \
    -X main.date="$(date +%Y-%m-%d)" \
    -X main.builtBy=nixpkgs"
  '';

  postInstall = ''
    mv $out/bin/main $out/bin/kubectl-testkube
    installShellCompletion --cmd kubectl-testkube \
      --bash <($out/bin/kubectl-testkube completion bash) \
      --fish <($out/bin/kubectl-testkube completion fish) \
      --zsh <($out/bin/kubectl-testkube completion zsh)
  '';

  meta = with lib; {
    description = "Kubernetes-native testing framework for test execution and orchestration";
    homepage = "https://testkube.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ mausch ];
  };
}
