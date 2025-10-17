{
  lib,
  config,
  pkgs,
  self',
  ...
}:
{
  options.erebus.profiles.graphical.enable =
    lib.mkEnableOption "graphical applications that are generally wanted on non-headless systems";

  config = lib.mkIf config.erebus.profiles.graphical.enable {
    erebus = {
      services = {
        aerospace.enable = true; # wm
        barik.enable = true; # bar
      };
    };

    environment.systemPackages = with pkgs; [
      betterdisplay
      grandperspective # disk usage visualiser
      iina # media player
      m-cli
      self'.packages.pearcleaner-bin
      utm
      whatsapp-for-mac
    ];

    homebrew.masApps.Xcode = 497799835;

    home-manager.sharedModules = lib.singleton {
      erebus.profiles.graphical.enable = true;
    };
  };
}
