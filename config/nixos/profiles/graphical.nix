{
  lib,
  config,
  ...
}: {
  options.erebus.profiles.graphical.enable = lib.mkEnableOption "graphical applications that are generally wanted on non-headless systems";

  config = lib.mkIf config.erebus.profiles.graphical.enable {
    erebus = {
      desktop.gnome.enable = true;
      system = {
        fonts.enable = true;
      };
    };

    home-manager.sharedModules = lib.singleton {
      erebus.programs = {
        discord.enable = true;
        blender.enable = true;
        ghostty.enable = true;
        zen.enable = true;
        pwa.enable = true;
      };
    };
  };
}
