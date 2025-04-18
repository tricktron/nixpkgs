{
  lib,
  buildNimPackage,
  fetchFromGitHub,
}:

buildNimPackage (finalAttrs: {
  pname = "c2nim";
  version = "0.9.19";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "c2nim";
    tag = finalAttrs.version;
    hash = "sha256-E8sAhTFIWAnlfWyuvqK8h8g7Puf5ejLEqgLNb5N17os=";
  };
  meta = finalAttrs.src.meta // {
    description = "Tool to translate Ansi C code to Nim";
    mainProgram = "c2nim";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ehmry ];
  };
})
