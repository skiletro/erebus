{
  lib,
  config,
  self',
  pkgs,
  ...
}:
{
  options.erebus.programs.blender.enable = lib.mkEnableOption "Blender and accompanying addons";

  config = lib.mkIf config.erebus.programs.blender.enable {
    home.packages = lib.singleton (
      if pkgs.stdenvNoCC.hostPlatform.isDarwin then self'.packages.blender-bin else pkgs.blender
    );
  };
}
