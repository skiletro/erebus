{
  config,
  lib,
  inputs,
  inputs',
  self,
  self',
  pkgs,
  ...
}:
{
  options.erebus.system.user.enable = lib.mkEnableOption "Jamie user";

  config = lib.mkIf config.erebus.system.user.enable {
    sops.secrets."user-password".neededForUsers = true;

    users = {
      mutableUsers = false; # forces declaration of user and group adding and modification
      users.jamie = {
        isNormalUser = true;
        hashedPasswordFile = config.sops.secrets.user-password.path;
        extraGroups = [
          "users"
          "networkmanager"
          "wheel"
          "libvirtd"
          "gamemode"
          "docker"
          "kvm"
        ];
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINnFEMa0S9zuA5cVg+Ktazz9gEevkDCNYIDX0WAMxcAC eos"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIcAzqMv0//j1mUVb/NBUiMgv2brdPv9HbNs83OkQZzq moirai"
        ];
      };
    };

    services.openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
    };

    # set default shell to fish
    programs.fish.enable = true; # For autocompletions. We will use the home manager module for configuration.

    # Set as default shell. See https://wiki.nixos.org/wiki/Fish#Setting_fish_as_default_shell
    programs.bash.interactiveShellInit = ''
      if [[ $(${lib.getExe' pkgs.procps "ps"} --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${lib.getExe pkgs.fish} $LOGIN_OPTION
      fi
    '';

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {
        inherit
          inputs
          inputs'
          self
          self'
          ;
      };
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
