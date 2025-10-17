{
  lib,
  config,
  inputs,
  inputs',
  self',
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenvNoCC.hostPlatform) isLinux isDarwin;
in
{
  imports = [
    inputs.diffy.homeModules.blender
  ];

  options.erebus.programs.blender.enable = lib.mkEnableOption "Blender and accompanying addons";

  config =
    lib.mkIf config.erebus.programs.blender.enable (
      lib.mkIf isLinux {
        programs.blender = {
          enable = true;
          addons = [
            inputs'.diffy.packages.cats-blender-plugin-unofficial
          ];
        };
      }
    )
    // (lib.mkIf isDarwin {
      home.packages = [ self'.packages.blender-bin ];
    });
}
