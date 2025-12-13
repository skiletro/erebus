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
      desktop = {
        gnome.enable = true;
        sway.enable = true;
        hyprland.enable = true;
      };
      system = {
        fonts.enable = true;
        greeter = "dankgreeter";
        virtualisation.enable = true;
      };
      programs = {
        lact.enable = true;
        unity.enable = true;
        vial.enable = true;
      };
      services = {
        protondrive.enable = true;
        rnnoise.enable = true;
        kdeconnect.enable = true;
        wireguard.enable = true;
        printing.enable = true;
      };
    };

    environment.systemPackages = with pkgs; [
      wineWowPackages.stable
      rustdesk-flutter
    ];

    home-manager.sharedModules = lib.singleton {
      erebus.profiles.graphical.enable = true;
    };
  };
}
