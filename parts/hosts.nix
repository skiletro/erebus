{
  lib,
  inputs,
  self,
  withSystem,
  ...
}:
let
  nixosHosts = {
    eris = "x86_64-linux";
    keres = "aarch64-linux";
  };

  darwinHosts = {
    moirai = "aarch64-darwin";
  };

  mkNixos =
    hostName: system:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs self; };

      modules = with inputs; [
        # Our own configuration files
        self.nixosModules.erebus
        self.nixosModules.shared
        (import-tree (self + /hosts/${hostName}))

        # Modules
        chaotic.nixosModules.default
        home-manager.nixosModules.default
        stylix.nixosModules.stylix
        sops-nix.nixosModules.sops
        (helperModules hostName system)
      ];
    };

  mkDarwin =
    hostName: system:
    inputs.nix-darwin.lib.darwinSystem {
      specialArgs = { inherit inputs self; };

      modules = with inputs; [
        # Our own configuration files
        self.darwinModules.erebus
        self.darwinModules.shared
        (import-tree (self + /hosts/${hostName}))

        # Modules
        home-manager.darwinModules.home-manager
        stylix.darwinModules.stylix
        sops-nix.darwinModules.sops

        # Fixes
        mac-app-util.darwinModules.default # fixes .app programs in Spotlight
        {
          home-manager.sharedModules = [
            inputs.mac-app-util.homeManagerModules.default
          ];
        }
        (helperModules hostName system)
      ];
    };

  helperModules = hostName: system: {
    # Useful helper function that lets us use self' and inputs' in replace of self and inputs.
    # For example, instead of inputs.helix.packages.x86_64-linux.helix, we could do inputs'.helix.packages.helix!
    _module.args = withSystem system (
      {
        self',
        inputs',
        ...
      }:
      {
        inherit self' inputs';
      }
    );
    # Sets some stuff that we need that doesn't really make sense elsewhere.
    networking = { inherit hostName; };
    nixpkgs.hostPlatform = system;
  };
in
{
  flake = {
    nixosConfigurations = lib.mapAttrs mkNixos nixosHosts;
    darwinConfigurations = lib.mapAttrs mkDarwin darwinHosts;
  };
}
