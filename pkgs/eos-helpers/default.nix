{
  pkgs,
  lib,
  stdenvNoCC,
  ...
}:
let
  inherit (pkgs.writers) writeNuBin;
  runFromNixScript =
    writeNuBin "," # nu
      ''
        # Runs a package from nixpkgs.
        # Shorthand for nix run nixpkgs#...
        def --wrapped main [package?: string, ...args: string]: any -> nothing {
          if (($package | is-empty) or $package == "--help" or $package == "-h") {
            help main | print
            return
          }

          with-env { NIXPKGS_ALLOW_UNFREE: "1" } {
              nix run $"nixpkgs#($package)" --impure -- ...$args
          }
        }
      '';
  shellFromNixScript =
    writeNuBin ",," # nu
      ''
        # Creates a nix-shell with specified packages.
        # Shorthand for nix shell nixpkgs#{...}
        def main [...packages: string]: any -> nothing {
          if ($packages | is-empty) {
            help main | print
            return
          }

          let specs = echo ...$packages | each { |pkg| $"nixpkgs#($pkg)"}
          with-env { NIXPKGS_ALLOW_UNFREE: "1" } {
            if (($specs | describe) == "list<string>") {
              nix shell ...$specs --impure
            } else {
              nix shell $specs --impure
            }
          }
        }
      '';
in
stdenvNoCC.mkDerivation {
  pname = "eos-helpers";
  version = "0.1";

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cp ${lib.getExe runFromNixScript} $out/bin/,
    cp ${lib.getExe shellFromNixScript} $out/bin/,,
  '';

  meta = {
    description = "Useful scripts for use in a Nix system";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
