{
  lib,
  config,
  pkgs,
  self',
  ...
}:
let
  inherit (pkgs.stdenvNoCC.hostPlatform) isLinux;
in
{
  options.erebus.profiles.graphical.enable =
    lib.mkEnableOption "graphical applications that are generally wanted on non-headless systems";

  config = lib.mkIf config.erebus.profiles.graphical.enable {
    erebus.programs = {
      discord.enable = true;
      blender.enable = lib.mkIf isLinux true;
      ghostty.enable = true;
      spotify.enable = true;
      pwa.enable = lib.mkIf isLinux true;
      zen.enable = true;
    };

    home.packages = [
      (with self'.packages; if isLinux then helium-linux else helium-macos)
    ];
  };
}
