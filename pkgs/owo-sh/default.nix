{
  pkgs,
  stdenv,
  fetchFromGitLab,
  ...
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "owo-sh";
  version = finalAttrs.src.rev;

  src = fetchFromGitLab {
    domain = "owo.codes";
    owner = "whats-this";
    repo = "owo.sh";
    rev = "d6ffda964cd6c81030f8e5516ca57c80a5a5dcb2";
    hash = "sha256-vwvUiM7mOixyNERjITwcS90jz15QFkwxCEtYzqm+hdg=";
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

  nativeBuildInputs = [ pkgs.curl ];
})
