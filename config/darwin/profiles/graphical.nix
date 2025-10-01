{
  lib,
  config,
  ...
}:
{
  options.erebus.profiles.graphical.enable =
    lib.mkEnableOption "graphical applications that are generally wanted on non-headless systems";

  config = lib.mkIf config.erebus.profiles.graphical.enable {
    erebus = {
      services = {
        aerospace.enable = true; # wm
        skhd.enable = true;
        barik.enable = true; # bar
      };
    };

    home-manager.sharedModules = lib.singleton {
      erebus.profiles.graphical.enable = true;
    };
  };
}
