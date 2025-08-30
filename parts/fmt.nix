{inputs, ...}: {
  imports = [inputs.treefmt-nix.flakeModule];

  perSystem = {config, ...}: {
    formatter = config.treefmt.build.wrapper;

    treefmt = {
      flakeCheck = true;
      programs = {
        deadnix.enable = true;
        just.enable = true;
        nixfmt.enable = true;
        statix.enable = true;
      };
    };
  };
}
