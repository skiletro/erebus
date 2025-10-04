{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem =
    { config, ... }:
    {
      formatter = config.treefmt.build.wrapper;

      treefmt = {
        flakeCheck = true;
        settings.global.excludes = [
          "*.age"
          "pkgs/_sources/generated.json"
          "pkgs/_sources/generated.nix"
        ];
        programs = {
          deadnix.enable = true;
          just.enable = true;
          nixfmt.enable = true;
          statix.enable = true;
        };
      };
    };
}
