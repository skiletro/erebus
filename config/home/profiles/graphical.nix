{
  lib,
  config,
  pkgs,
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
      blender.enable = true;
      discord.enable = true;
      ghostty.enable = true;
      helium.enable = true;
      libreoffice.enable = true;
      proton.enable = true;
      pwa.enable = lib.mkIf isLinux true; # TODO: need to find a solution for pwa declaration on darwin
      spotify.enable = true;
      zed.enable = true;
      zen.enable = lib.mkIf isLinux true; # TODO: compiles but doesn't launch on darwin
    };

    home.packages = with pkgs; [
      obsidian
      qbittorrent
      signal-desktop-bin
    ];
  };
}
