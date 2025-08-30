{
  lib,
  config,
  ...
}:
{
  options.services.desktopManager.gnome = {
    extensions = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
    };
  };

  config = {
    environment.systemPackages = config.services.desktopManager.gnome.extensions;

    home-manager.sharedModules = lib.singleton {
      dconf = {
        enable = lib.mkDefault true;
        settings = {
          "org/gnome/shell" = {
            disable-user-extensions = false;
            enabled-extensions =
              map (ext: ext.extensionUuid) config.services.desktopManager.gnome.extensions
              ++ lib.optional config.stylix.enable "user-theme@gnome-shell-extensions.gcampax.github.com";
          };
        };
      };
    };
  };
}
