{inputs, ...}: {
  flake = {
    nixosModules.erebus = inputs.import-tree ./nixos;
    homeModules.erebus = inputs.import-tree ./home;
  };
}
