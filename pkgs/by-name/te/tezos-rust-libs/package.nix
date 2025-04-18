{
  lib,
  fetchFromGitLab,
  stdenv,
  llvmPackages,
  cargo,
  libiconv,
}:

stdenv.mkDerivation rec {
  version = "1.5";
  pname = "tezos-rust-libs";
  src = fetchFromGitLab {
    owner = "tezos";
    repo = "tezos-rust-libs";
    tag = "v${version}";
    hash = "sha256-SuCqDZDXmWdGI/GN+3nYcUk66jnW5FQQaeTB76/rvaw=";
  };

  nativeBuildInputs = [
    llvmPackages.llvm
    cargo
  ];
  propagatedBuildInputs = [ llvmPackages.libllvm ];
  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  buildPhase = ''
    runHook preBuild

    cargo build \
      --target-dir target-librustzcash \
      --package librustzcash \
      --release

    cargo build \
      --target-dir target-wasmer \
      --package wasmer-c-api \
      --no-default-features \
      --features singlepass,cranelift,wat,middlewares,universal \
      --release

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/tezos-rust-libs/rust
    cp "librustzcash/include/librustzcash.h" \
        "target-librustzcash/release/librustzcash.a" \
        "wasmer-2.3.0/lib/c-api/wasm.h" \
        "wasmer-2.3.0/lib/c-api/wasmer.h" \
        "target-wasmer/release/libwasmer.a" \
        "$out/lib/tezos-rust-libs"
    cp -r "librustzcash/include/rust" "$out/lib/tezos-rust-libs"

    runHook postInstall
  '';

  cargoVendorDir = "./vendor";

  meta = {
    homepage = "https://gitlab.com/tezos/tezos-rust-libs";
    description = "Tezos: all rust dependencies and their dependencies";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
