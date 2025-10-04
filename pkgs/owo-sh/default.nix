{
  pkgs,
  stdenv,
  sources,
  lib,
  ...
}:
stdenv.mkDerivation {
  inherit (sources.owo-sh) pname version src;

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "DESTDIR="
  ];

  # Ensure the bin directory exists
  preBuild = ''
    mkdir -p $out/bin
  '';

  # Install using the Makefile's install target
  installPhase = ''
    make install PREFIX=$out DESTDIR=""
  '';

  nativeBuildInputs = [ pkgs.curl ];
}
