{
  lib,
  config,
  inputs,
  inputs',
  ...
}:
{
  imports = [
    inputs.diffy.homeModules.blender
  ];

  options.erebus.programs.blender.enable = lib.mkEnableOption "Blender and accompanying addons";

  config = lib.mkIf config.erebus.programs.blender.enable {
    programs.blender = {
      enable = true;
      addons = [
        inputs'.diffy.packages.cats-blender-plugin-unofficial
      ];
    };
  };
}
