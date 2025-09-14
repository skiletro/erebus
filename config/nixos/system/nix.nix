{ config, ... }:
{
  nix = {
    # set nix path properly
    nixPath = [
      "nixos-config=/home/jamie/Projects/erebus/flake.nix"
      "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    ];

    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];
      trusted-users = [
        "jamie"
        "root"
        "@wheel"
      ]; # Fixes some "cannot connect to socket" issues
      warn-dirty = false;
      http-connections = 50;
      log-lines = 50;
      builders-use-substitutes = true;
      accept-flake-config = true;
    };

    optimise = {
      automatic = true;
      dates = [
        "03:45"
        "07:00"
      ];
    };
  };

  nixpkgs.config.allowUnfree = true;
}
