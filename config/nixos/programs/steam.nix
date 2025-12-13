{
  config,
  lib,
  pkgs,
  inputs',
  self,
  self',
  ...
}:
{
  imports = [ self.nixosModules.steam ];

  options.erebus.programs.steam.enable = lib.mkEnableOption "Steam and Steam tools";

  config = lib.mkIf config.erebus.programs.steam.enable {
    programs.steam = {
      enable = true;
      package = pkgs.steam.override {
        extraProfile = ''
          export DXVK_HUD=compiler,fps
          export PROTON_ENABLE_WAYLAND=1
          export PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES=1
          unset TZ
        '';
      };
      stylix.enable = true;
      extraCompatPackages = with pkgs; [
        self'.packages.proton-cachyos_x86_64_v3
        inputs'.nixpkgs-xr.packages.proton-ge-rtsp-bin
        steam-play-none # Allows you to run a game without Proton if it is otherwise forced.
      ];
      extest.enable = true;
      protontricks.enable = true;
      gamescopeSession.enable = true;
    };

    home-manager.sharedModules = lib.singleton (userAttrs: {
      xdg.autostart.entries = userAttrs.config.lib.erebus.autostartEntry "Steam Silent" "${lib.getExe config.programs.steam.package} -silent -console";
    });

    environment.systemPackages = [ pkgs.sgdboop ]; # Setting SteamGridDB art easier

    boot.kernel.sysctl."vm.max_map_count" = 2147483642; # Some Steam games like this, idk why
  };
}
