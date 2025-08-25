{
  lib,
  config,
  ...
}: {
  options.erebus.profiles.terminal.enable = lib.mkEnableOption "terminal applications that are generally wanted on all systems, but aren't required like the `base` profile.";

  config = lib.mkIf config.erebus.profiles.terminal.enable {
    erebus.programs = {
      fish.enable = true;
    };

    home-manager.sharedModules = lib.singleton {
      erebus.programs = {
        bat.enable = true;
        beets.enable = true;
        direnv.enable = true;
        eza.enable = true;
        fastfetch.enable = true;
        git.enable = true;
        helix.enable = true;
        yazi.enable = true;
      };
    };
  };
}
