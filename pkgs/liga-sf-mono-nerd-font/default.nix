{
  stdenvNoCC,
  fetchgit,
  ...
}:
stdenvNoCC.mkDerivation {
    pname = "liga-sf-mono-nerd-font";
    version = "dc5a3e6fcc2e16ad476b7be3c3c17c2273b260ea";
    src = fetchgit {
      url = "https://github.com/shaunsingh/SFMono-Nerd-Font-Ligaturized.git";
      rev = "dc5a3e6fcc2e16ad476b7be3c3c17c2273b260ea";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sparseCheckout = [ ];
      sha256 = "sha256-AYjKrVLISsJWXN6Cj74wXmbJtREkFDYOCRw1t2nVH2w=";
    };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    cp -R $src/*.otf $out/share/fonts/opentype
  '';
}
