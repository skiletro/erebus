{
  lib,
  stdenv,
  sources,
  pkg-config,
  meson,
  ninja,
  libX11,
  libXrender,
  libXrandr,
  libXext,
  libglvnd,
  wayland,
  wayland-scanner,
  ...
}:

stdenv.mkDerivation {
  inherit (sources.gpu-screen-recorder-notification) pname version src;

  postPatch = ''
    substituteInPlace depends/mglpp/depends/mgl/src/gl.c \
      --replace-fail "libGL.so.1" "${lib.getLib libglvnd}/lib/libGL.so.1" \
      --replace-fail "libGLX.so.0" "${lib.getLib libglvnd}/lib/libGLX.so.0" \
      --replace-fail "libEGL.so.1" "${lib.getLib libglvnd}/lib/libEGL.so.1"
  '';

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];

  buildInputs = [
    libX11
    libXrender
    libXrandr
    libXext
    libglvnd
    wayland
    wayland-scanner
  ];

  meta = {
    description = "Notification in the style of ShadowPlay";
    homepage = "https://git.dec05eba.com/gpu-screen-recorder-notification/about/";
    license = lib.licenses.gpl3Only;
    mainProgram = "gsr-notify";
    platforms = lib.platforms.linux;
  };
}
