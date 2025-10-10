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
      blender.enable = lib.mkIf isLinux true;
      discord.enable = true;
      ghostty.enable = true;
      pwa.enable = lib.mkIf isLinux true;
      spotify.enable = true;
      zen.enable = lib.mkIf isLinux true; # battery life isnt great on mac
    };

    home.packages = with pkgs; [
      tor-browser
      (with self'.packages; if isLinux then helium-linux else helium-macos)
    ];
  };
}
