{ inputs, ... }:
{
  flake = {
    nixosModules.erebus = inputs.import-tree ./nixos;
    homeModules.erebus = inputs.import-tree ./home;
    darwinModules.erebus = inputs.import-tree ./darwin;
  };
}
