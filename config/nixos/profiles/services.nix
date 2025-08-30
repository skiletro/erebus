{
  lib,
  config,
  ...
}: {
  options.erebus.profiles.services.enable = lib.mkEnableOption "background services";

  config = lib.mkIf config.erebus.profiles.services.enable {
    erebus.services = {
    };
  };
}
