{inputs, ...}: {
  imports = [
    ../config
    ../modules
    ../pkgs

    inputs.home-manager.flakeModules.home-manager
  ];
}
