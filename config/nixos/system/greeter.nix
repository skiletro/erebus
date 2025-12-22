{
  config,
  lib,
  ...
}:
let
  inherit (config.erebus.system) greeter;
  inherit (lib)
    mkMerge
    mkOption
    mkIf
    types
    ;
in
{
  options.erebus.system.greeter = mkOption {
    type = types.nullOr (
      types.enum [
        "dankgreeter"
        "gdm"
      ]
    );
    default = null;
  };

  config = mkMerge [
    (mkIf (greeter == "gdm") {
      services.displayManager.gdm.enable = true;
    })
    (mkIf (greeter == "dankgreeter") {
      services.displayManager.dms-greeter = {
        enable = true;
        compositor.name = "sway";
        configHome = "/home/jamie";
      };
      programs.sway.enable = true;
    })
  ];
}
