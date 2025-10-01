{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.erebus.services.aerospace.enable = lib.mkEnableOption "Aerospace window manager";

  config = lib.mkIf config.erebus.services.aerospace.enable {
    environment.systemPackages = [ pkgs.aerospace ]; # TODO: define config here, and use darwin module.
  };
}
