{ inputs, ... }:
{
  imports = [ inputs.nix-rosetta-builder.darwinModules.default ];

  nix-rosetta-builder = {
    enable = true;
    onDemand = true;
    onDemandLingerMinutes = 30;
  };
}
