{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "iamy";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "99designs";
    repo = "iamy";
    tag = "v${version}";
    sha256 = "sha256-oH3ijZaWXI0TdVQN9gzp5ypWzY7OqSxDh7VBoZo42Cs=";
  };

  vendorHash = "sha256-/IUYM3pTvcHXw8t5MW6JUEWdxegFuQC8zkiySp8VEgE=";

  ldflags = [
    "-X main.Version=v${version}"
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Cli tool for importing and exporting AWS IAM configuration to YAML files";
    homepage = "https://github.com/99designs/iamy";
    license = licenses.mit;
    maintainers = with maintainers; [ suvash ];
    mainProgram = "iamy";
  };
}
