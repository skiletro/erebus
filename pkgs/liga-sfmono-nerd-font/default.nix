{
  stdenvNoCC,
  fetchFromGitHub,
  ...
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "liga-sfmono-nerd-font";
  version = "dc5a3e6fcc2e16ad476b7be3c3c17c2273b260ea";

  src = fetchFromGitHub {
    owner = "shaunsingh";
    repo = "SFMono-Nerd-Font-Ligaturized";
    rev = finalAttrs.version;
    hash = "sha256-AYjKrVLISsJWXN6Cj74wXmbJtREkFDYOCRw1t2nVH2w=";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    cp -R $src/*.otf $out/share/fonts/opentype
  '';
})
