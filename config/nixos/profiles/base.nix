{
  lib,
  config,
  ...
}:
{
  options.erebus.profiles.base.enable =
    lib.mkEnableOption "base configuration required for virtually all configs";

  config = lib.mkIf config.erebus.profiles.base.enable {
    erebus = {
      system = {
        boot.enable = true;
        locale.enable = true;
        user.enable = true;
      };

      services.tailscale.enable = true;
    };
  };
}
