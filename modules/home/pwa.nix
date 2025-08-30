{
  lib,
  config,
  ...
}:
{
  options.programs.firefoxpwa.webapps = lib.mkOption {
    default = { };
    type =
      with lib.types;
      attrsOf (submodule {
        options = {
          url = lib.mkOption {
            type = str;
          };
          manifestUrl = lib.mkOption {
            type = str;
          };
          categories = lib.mkOption {
            type = listOf str;
          };
          icon = lib.mkOption {
            type = str; # TODO: this option can also technically include paths :)
          };
        };
      });
  };

  config =
    let
      genUlid =
        string: "0123456789${builtins.hashString "md5" string |> builtins.substring 0 16 |> lib.toUpper}";

      mkWebapp =
        name: cfg:
        lib.nameValuePair "${genUlid cfg.url}" {
          sites."${genUlid cfg.manifestUrl}" = {
            name = name;
            url = cfg.url;
            manifestUrl = cfg.manifestUrl;
            desktopEntry = {
              enable = true;
              categories = cfg.categories;
              icon = cfg.icon;
            };
          };
        };
    in
    lib.mkIf config.programs.firefoxpwa.enable {
      programs.firefoxpwa.profiles = lib.mapAttrs' mkWebapp config.programs.firefoxpwa.webapps;
    };
}
