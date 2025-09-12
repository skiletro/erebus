{
  nixpkgs = {
    config.allowUnfree = true;
  };

  nix = {
    enable = true;
    channel.enable = false;
    settings = {
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
      lazy-trees = true;
    };
    optimise.automatic = true;
  };
}
