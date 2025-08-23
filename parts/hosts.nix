{
  lib,
  inputs,
  self,
  withSystem,
  ...
}: let
  nixosHosts = {
    vm = "x86_64-linux";
  };

  darwinHosts = {
    moirai = "aarch64-darwin";
  };

  mkNixos = hostName: system:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs self;};

      modules = with inputs; [
        # Our own configuration files
        self.nixosModules.erebus
        (import-tree (self + /hosts/${hostName}))

        # Modules
        chaotic.nixosModules.default
        determinate.nixosModules.default
        home-manager.nixosModules.default
        stylix.nixosModules.stylix

        (helperModules hostName system)
      ];
    };

  mkDarwin = hostName: system:
    inputs.nix-darwin.lib.darwinSystem {
      specialArgs = {inherit inputs self;};

      modules = with inputs; [
        # Our own configuration files
        self.darwinModules.erebus
        (import-tree (self + /hosts/${hostName}))

        # Modules
        home-manager.darwinModules.home-manager

        (helperModules hostName system)
      ];
    };

  helperModules = hostName: system: {
    # Useful helper function that lets us use self' and inputs' in replace of self and inputs.
    # For example, instead of inputs.helix.packages.x86_64-linux.helix, we could do inputs'.helix.packages.helix!
    _module.args = withSystem system ({
      self',
      inputs',
      ...
    }: {inherit self' inputs';});
    # Sets some stuff that we need that doesn't really make sense elsewhere.
    networking = {inherit hostName;};
    nixpkgs.hostPlatform = system;
  };
in {
  flake = {
    nixosConfigurations = lib.mapAttrs mkNixos nixosHosts;
    darwinConfigurations = lib.mapAttrs mkDarwin darwinHosts;
  };
}
