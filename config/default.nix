{ inputs, ... }:
{
  flake = {
    nixosModules.erebus = inputs.import-tree ./nixos;
    homeModules.erebus = inputs.import-tree ./home;
    darwinModules.erebus = inputs.import-tree ./darwin;

    nixosModules.shared = inputs.import-tree ./shared;
    darwinModules.shared = inputs.import-tree ./shared;
  };
}
