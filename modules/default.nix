{ lib, ... }:
let
  isImportable =
    path: type:
    (type == "directory" && lib.pathExists (lib.path.append path "default.nix"))
    || (type == "regular" && lib.hasSuffix ".nix" path);

  importModules =
    dir:
    builtins.readDir dir
    |> lib.filterAttrs (name: type: isImportable (lib.path.append dir name) type)
    |> lib.mapAttrs' (
      name: _: {
        name = lib.toCamelCase (lib.removeSuffix ".nix" name);
        value = import (lib.path.append dir name);
      }
    );

  genModuleAttrs = type: {
    flake."${type}Modules" = importModules ./${type};
  };
in
{
  imports = map genModuleAttrs [
    "home"
    "nixos"
  ];
}
