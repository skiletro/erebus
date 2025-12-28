{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenvNoCC.hostPlatform) isDarwin isLinux;
in
{
  options.erebus.profiles.graphical.enable =
    lib.mkEnableOption "graphical applications that are generally wanted on non-headless systems";

  config = lib.mkIf config.erebus.profiles.graphical.enable {
    erebus.programs = {
      blender.enable = true;
      discord.enable = true;
      ghostty.enable = lib.mkIf isDarwin true; # TODO: Transfer over to kitty on macOS too.
      helium.enable = true;
      kitty.enable = lib.mkIf isLinux true;
      libreoffice.enable = true;
      obsidian.enable = true;
      proton.enable = true;
      pwa.enable = lib.mkIf isLinux true; # TODO: need to find a solution for pwa declaration on darwin
      rider.enable = true;
      spotify.enable = true;
      zen.enable = lib.mkIf isLinux true; # TODO: compiles but doesn't launch on darwin
    };

    home.packages = with pkgs; [
      qbittorrent
      signal-desktop-bin
    ];
  };
}
