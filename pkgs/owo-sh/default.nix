{
  pkgs,
  stdenv,
  lib,
  ...
}:
stdenv.mkDerivation {
  owo-sh = {
    pname = "owo-sh";
    version = "d6ffda964cd6c81030f8e5516ca57c80a5a5dcb2";
    src = fetchgit {
      url = "https://owo.codes/whats-this/owo.sh.git";
      rev = "d6ffda964cd6c81030f8e5516ca57c80a5a5dcb2";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sparseCheckout = [ ];
      sha256 = "sha256-vwvUiM7mOixyNERjITwcS90jz15QFkwxCEtYzqm+hdg=";
    };
    date = "2023-04-10";
  };

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

  patchPhase = ''
    substituteInPlace bin/owo \
      --replace "file -bIL" "file -biL"
  '';

  nativeBuildInputs = [ pkgs.curl ];

  meta = {
    description = "Shell uploader/shortener script for whats-th.is";
    homepage = "https://owo.codes/whats-this/owo.sh/";
    license = lib.licenses.gpl3;
  };
}
