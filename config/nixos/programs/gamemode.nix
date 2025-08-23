{
  config,
  lib,
  pkgs,
  ...
}: {
  options.erebus.programs.gamemode.enable = lib.mkEnableOption "Gamemode, a game optimiser";

  config = lib.mkIf config.erebus.programs.gamemode.enable {
    programs.gamemode = {
      enable = true;
      enableRenice = true;
      settings = {
        general = {
          softrealtime = "auto";
          renice = 15;
        };
        custom = let
          powerprofilesctl = lib.getExe pkgs.power-profiles-daemon;
        in {
          start =
            (pkgs.writeShellScript "gamemode-start"
              # sh
              ''
                ${powerprofilesctl} set performance
              '').outPath;
          end =
            (pkgs.writeShellScript "gamemode-end"
              # sh
              ''
                ${powerprofilesctl} set power-saver
              '').outPath;
        };
      };
    };
  };
}
