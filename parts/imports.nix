{inputs, ...}: {
  imports = [
    ../config
    ../modules

    inputs.home-manager.flakeModules.home-manager
  ];
}
