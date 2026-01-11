{
  stdenvNoCC,
  nushell,
  nvfetcher,
  git,
  nh,
  makeWrapper,
  lib,
  ...
}:
let
  flakeLocation = "/home/jamie/Projects/erebus";
in
stdenvNoCC.mkDerivation (attrs: {
  pname = "eos-cli";
  version = "0.1";

  src = ./.;

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    nushell
    nvfetcher
    git
    nh
  ];

  NH_FLAKE = "$HOME/Projects/erebus";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -m755 $src/eos.nu $out/bin/eos

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/eos \
      --prefix PATH : ${lib.makeBinPath attrs.buildInputs} \
      --set NH_FLAKE "${flakeLocation}" \
      --chdir "${flakeLocation}" \
      --inherit-argv0
  '';

  meta.mainProgram = "eos";
})
