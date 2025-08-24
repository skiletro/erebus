{
  lib,
  stdenv,
  fetchFromGitHub,
  ...
}:
stdenv.mkDerivation (_finalAttrs: {
  pname = "base16-schemes-unstable";
  version = "0-unstable-2025-08-09";

  src = fetchFromGitHub {
    owner = "tinted-theming";
    repo = "schemes";
    rev = "097d751b9e3c8b97ce158e7d141e5a292545b502";
    hash = "sha256-8KG2lXGaXLUE0F/JVwLQe7kOVm21IDfNEo0gfga5P4M=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/themes/
    install base16/*.yaml $out/share/themes/

    runHook postInstall
  '';

  meta = {
    description = "All the color schemes for use in base16 packages";
    homepage = "https://github.com/tinted-theming/schemes";
    license = lib.licenses.mit;
  };
})
