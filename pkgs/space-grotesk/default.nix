{
  stdenvNoCC,
  fetchzip,
  ...
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "space-grotesk";
  version = "2.0.0";

  src = fetchzip {
    url = "https://github.com/floriankarsten/space-grotesk/releases/download/${finalAttrs.version}/SpaceGrotesk-${finalAttrs.version}.zip";
    sha256 = "sha256-niwd5E3rJdGmoyIFdNcK5M9A9P2rCbpsyZCl7CDv7I8=";
    stripRoot = false; # we need this because a _MACOSX folder exists in the zip file
  };

  installPhase = ''
    mkdir -p $out/share/fonts
    cp -R $src/SpaceGrotesk-${finalAttrs.version}/otf $out/share/fonts/opentype
  '';
})
