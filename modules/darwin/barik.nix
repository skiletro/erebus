{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.services.barik = {
    enable = lib.mkEnableOption "Barik status bar";
    settings = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };
  };

  config = lib.mkIf config.services.barik.enable {
    # TODO: package this, as to not have to rely on homebrew.
    homebrew = {
      casks = [ "barik" ];
      taps = [ "mocki-toki/formulae" ];
    };

    home-manager.sharedModules = lib.singleton {
      home.file.".barik-config.toml".source = (pkgs.formats.toml { }).generate "barik-config" (
        lib.mergeAttrsList [
          {
            aerospace.path = lib.mkIf config.services.aerospace.enable config.services.aerospace.package;
            yabai.path = lib.mkIf config.services.yabai.enable config.services.yabai.package;
          }
          config.services.barik.settings
        ]
      );
    };
  };
}
