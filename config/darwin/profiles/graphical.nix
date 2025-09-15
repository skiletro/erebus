{
  lib,
  config,
  ...
}:
{
  options.erebus.profiles.graphical.enable =
    lib.mkEnableOption "graphical applications that are generally wanted on non-headless systems";

  config = lib.mkIf config.erebus.profiles.graphical.enable {
    home-manager.sharedModules = lib.singleton {
      erebus.profiles.graphical.enable = true;
    };
  };
}
