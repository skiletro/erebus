{
  config,
  lib,
  inputs,
  inputs',
  self,
  self',
  pkgs,
  ...
}: {
  options.erebus.system.user.enable = lib.mkEnableOption "Jamie user";

  config = lib.mkIf config.erebus.system.user.enable {
    users.users.jamie = {
      name = "jamie";
      home = "/Users/jamie";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINnFEMa0S9zuA5cVg+Ktazz9gEevkDCNYIDX0WAMxcAC eos"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIcAzqMv0//j1mUVb/NBUiMgv2brdPv9HbNs83OkQZzq moirai"
      ];
    };

    # set default shell to fish
    # TODO: Make this less crude. Currently there is no way to run zsh.
    # Probabyl make it so Ghostty runs fish as a command on startup,
    # instead of having it embedded in the .zshrc?
    # programs.zsh = {
    #   promptInit = let
    #     fish = lib.getExe pkgs.fish;
    #   in ''
    #     [ -x ${fish} ] && SHELL=${fish} exec ${fish}
    #   '';
    # };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {inherit inputs inputs' self self';};
      users.jamie = {
        home.stateVersion = "25.11";
        imports = [
          self.homeModules.erebus
          self.homeModules.autostart
          # inputs.chaotic.homeModules.default
          {
            programs.ghostty.settings.command = lib.getExe pkgs.fish;
          }
        ];
      };
    };
  };
}
