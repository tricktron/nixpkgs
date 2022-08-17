{ lib, stdenv
, fetchFromGitLab
, meson
, ninja
, pkg-config
, python3Packages
, vulkan-headers
, vulkan-loader
, shaderc
, glslang
, lcms2
, libepoxy
, libGL
, xorg
, libunwind
, ffmpeg_5
, SDL2
, SDL2_image
}:

stdenv.mkDerivation rec {
  pname = "libplacebo";
  version = "4.208.0";

  src = fetchFromGitLab {
    domain = "code.videolan.org";
    owner = "videolan";
    repo = pname;
    fetchSubmodules = true;
    rev = "1d3ff4d4091a8c91cecdf3f1892ed0d1e1bf01cc";
    sha256 = "sha256-C5Akp+BLp/QojyhRRQzW83OieNJkmC/ECJKPsAkKdPk=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3Packages.Mako
    python3Packages.setuptools
    glslang # needed at runtime for the demos
  ];

  buildInputs = [
    vulkan-headers
    vulkan-loader
    shaderc
    lcms2
    libepoxy
    libGL
    xorg.libX11
    libunwind
    ffmpeg_5
    SDL2
    SDL2_image
  ];

  mesonFlags = [
    "-Dvulkan=enabled"
    "-Dvulkan-registry=${vulkan-headers}/share/vulkan/registry/vk.xml"
    "-Dvulkan-link=true"
    "-Ddebug-abort=true"
    "-Dglslang=enabled"
    "-Dopengl=disabled"
    "-Dshaderc=disabled"
    "-Dd3d11=disabled" # Disable the Direct3D 11 based renderer
  ] ++ lib.optionals stdenv.isDarwin [
    "-Dunwind=disabled" # libplacebo doesn’t build with `darwin.libunwind`
  ];

  LD_LIBRARY_PATH = "${vulkan-loader}/lib"; # needed for the demos at runtime

  meta = with lib; {
    description = "Reusable library for GPU-accelerated video/image rendering primitives";
    longDescription = ''
      Reusable library for GPU-accelerated image/view processing primitives and
      shaders, as well a batteries-included, extensible, high-quality rendering
      pipeline (similar to mpv's vo_gpu). Supports Vulkan, OpenGL and Metal (via
      MoltenVK).
    '';
    homepage = "https://code.videolan.org/videolan/libplacebo";
    changelog = "https://code.videolan.org/videolan/libplacebo/-/tags/v${version}";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ primeos tadeokondrak ];
    platforms = platforms.all;
  };
}
