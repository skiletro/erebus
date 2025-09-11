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
    onActivation.cleanup = "zap";
    taps = [
      "nikitabobko/tap" # aerospace, TODO: remove this once converted to a nix service
    ];
  };
}
