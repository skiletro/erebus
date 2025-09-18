{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.erebus.profiles.graphical.enable =
    lib.mkEnableOption "graphical applications that are generally wanted on non-headless systems";

  config = lib.mkIf config.erebus.profiles.graphical.enable {
    erebus = {
      desktop.gnome.enable = true;
      system = {
        fonts.enable = true;
        virtualisation.enable = true;
      };
      programs = {
        lact.enable = true;
        vial.enable = true;
      };
      services = {
        rnnoise.enable = true;
        wireguard.enable = true;
      };
    };

    environment.systemPackages = with pkgs; [ wineWowPackages.stable ];

    home-manager.sharedModules = lib.singleton {
      erebus.profiles.graphical.enable = true;
    };
  };
}
