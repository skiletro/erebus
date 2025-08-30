{ inputs, ... }:
{
  imports = [ inputs.nix-homebrew.darwinModules.nix-homebrew ];

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = "jamie";
    autoMigrate = true;
  };

  homebrew = {
    enable = true;
  };
}
