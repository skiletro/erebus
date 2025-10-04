{ lib, ... }:
{
  perSystem =
    {
      pkgs,
      self',
      ...
    }:
    {
      packages =
        builtins.readDir ./.
        |> lib.filterAttrs (name: value: value == "directory" && name != "_sources")
        |> lib.mapAttrs (
          name: _: pkgs.callPackage ./${name} ({ inherit (self') sources; } // self'.packages)
        );

      sources = import ./_sources/generated.nix {
        inherit (pkgs)
          fetchgit
          fetchurl
          fetchFromGitHub
          dockerTools
          ;
      };
    };
}
