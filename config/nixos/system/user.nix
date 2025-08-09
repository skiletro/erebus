{
  config,
  lib,
  inputs,
  inputs',
  self,
  self',
  ...
}: {
  options.erebus.system.user.enable = lib.mkEnableOption "Jamie user";

  config = lib.mkIf config.erebus.system.user.enable {
    users.users.jamie = {
      isNormalUser = true;
      password = "pwd"; # TODO: Change me to hashedPasswordFile, embedded in a secret.
      extraGroups = ["users" "networkmanager" "wheel" "libvirtd" "gamemode"];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINnFEMa0S9zuA5cVg+Ktazz9gEevkDCNYIDX0WAMxcAC eos"
      ];
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {inherit inputs inputs' self self';};
      users.jamie.imports = [
        self.homeModules.erebus
        self.homeModules.autostart
        {
          home = {
            username = "jamie";
            homeDirectory = "/home/jamie";
            stateVersion = "25.05";
          };
        }
      ];
    };
  };
}
