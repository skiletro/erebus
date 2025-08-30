{
  stdenvNoCC,
  fetchurl,
  ...
}:
stdenvNoCC.mkDerivation (_finalAttrs: {
  pname = "apple-emoji";
  version = "18.4";

  src = fetchurl {
    url = "https://github.com/samuelngs/apple-emoji-linux/releases/download/v18.4/AppleColorEmoji.ttf";
    sha256 = "sha256-pP0He9EUN7SUDYzwj0CE4e39SuNZ+SVz7FdmUviF6r0=";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp -R $src $out/share/fonts/truetype/AppleColorEmoji.ttf
  '';
})
