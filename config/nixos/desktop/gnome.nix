{
  config,
  lib,
  pkgs,
  ...
}: {
  options.erebus.desktop.gnome.enable = lib.mkEnableOption "Gnome desktop and accompanying programs.";

  config = lib.mkIf config.erebus.desktop.gnome.enable {
    services.desktopManager.gnome.enable = true;
    services.displayManager.gdm.enable = true;

    environment.systemPackages = with pkgs.gnomeExtensions; [
      dash-to-panel
    ];

    home-manager.sharedModules = lib.singleton {
      dconf = {
        enable = true;
        settings = {
          "org/gnome/desktop/interface" = {
            accent-color = "red";
          };
        };
      };
    };
  };
}
