{ buildGoModule, fetchFromGitHub, lib, stdenv, installShellFiles }:

buildGoModule rec {
  pname = "testkube";
  version = "1.11.18";

  src = fetchFromGitHub {
    owner = "kubeshop";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-bkQrnVLUu8eDN2AYLtLi0sLRuYIFFeXFWnuSr+I1670=";
    # We need the git revision
    leaveDotGit = true;
    postFetch = ''
      git -C $out rev-parse --short HEAD > $out/.git-revision
      rm -rf $out/.git
    '';
  };

  nativeBuildInputs = [ installShellFiles ];

  vendorSha256 = "sha256-iyR9H5T1eRjEx3vUgxUkXK6fgvJfLb7ux7MdIM3vPOY=";
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
