{
  lib,
  config,
  pkgs,
  self',
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
    environment.systemPackages = [ self'.packages.barik-bin ];

    home-manager.sharedModules = lib.singleton {
      home.file.".barik-config.toml" = {
        source = (pkgs.formats.toml { }).generate "barik-config" config.services.barik.settings;
        onChange = # sh
          ''
            ${lib.getExe' pkgs.toybox "pkill"} Barik
            open -a Barik.app
          '';
      };
    };
  };
}
