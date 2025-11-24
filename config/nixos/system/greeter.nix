{
  config,
  lib,
  inputs,
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
  imports = [
    inputs.dankMaterialShell.nixosModules.greeter
  ];

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
      programs.dankMaterialShell.greeter = {
        enable = true;
        compositor.name = "sway"; # compositor to run the greeter
        configHome = "/home/jamie";
        logs = {
          save = true;
          path = "/tmp/dms-greeter.log";
        };
      };
    })
  ];
}
