{
  lib,
  config,
  self',
  ...
}:
{
  options.erebus.programs.helium.enable = lib.mkEnableOption "Helium Browser";

  config = lib.mkIf config.erebus.programs.helium.enable {
    home.packages = [ self'.packages.helium-bin ];
  };
}
