{
  lib,
  config,
  ...
}: {
  options.erebus.profiles.gaming.enable = lib.mkEnableOption "gaming related *stuff*. This includes VR.";

  config = lib.mkIf config.erebus.profiles.gaming.enable {
    erebus = {
      programs = {
        gamemode.enable = true;
        steam.enable = true;
        wivrn.enable = true;
      };

      services = {
        sunshine.enable = true;
      };
    };
  };
}
