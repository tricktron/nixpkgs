{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "trillian";
  version = "1.7.0";
  vendorHash = "sha256-5zUCDKOeINVN/4PWDzqWMRhELc2wRvgJNdOJSAsFwUA=";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-E4A53Jru69sPIcB6Ydv8KauzjS9jvfhm5VbH69bfrt4=";
  };

  subPackages = [
    "cmd/trillian_log_server"
    "cmd/trillian_log_signer"
    "cmd/createtree"
    "cmd/deletetree"
    "cmd/updatetree"
  ];

  meta = with lib; {
    homepage = "https://github.com/google/trillian";
    description = "Transparent, highly scalable and cryptographically verifiable data store";
    license = [ licenses.asl20 ];
    maintainers = [ ];
  };
}
