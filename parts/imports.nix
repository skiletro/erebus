{ inputs, ... }:
{
  imports = [
    ../config
    ../modules
    ../pkgs
    (inputs.import-tree ../modules/flake)
  ];
}
