{
  lib,
  config,
  ...
}: {
  options.erebus.profiles.gaming.enable = lib.mkEnableOption "gaming related *stuff*. This includes VR.";

  config =
    lib.mkIf config.erebus.profiles.gaming.enable {
    };
}
