{
  config,
  lib,
  pkgs,
  inputs,
  inputs',
  self,
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
          export PROTON_ENABLE_WAYLAND=1
          export PRESSURE_VESSEL_FILESYSTEMS_RW="$XDG_RUNTIME_DIR/wivrn/comp_ipc"
          unset TZ
        '';
      };
      stylix.enable = true;
      extraCompatPackages = with pkgs; [
        proton-cachyos_x86_64_v3
        proton-ge-custom
        steam-play-none # Allows you to run a game without Proton if it is otherwise forced.
      ];
      extest.enable = true;
      protontricks.enable = true;
    };

    home-manager.sharedModules = lib.singleton (userAttrs: {
      imports = [ inputs.steam-config-nix.homeModules.default ];

      programs.steam.config = {
        enable = true;
        closeSteam = true;
      };

      xdg.autostart.entries = userAttrs.config.lib.erebus.autostartEntry "Steam Silent" "${lib.getExe config.programs.steam.package} -silent -console";
    });

    environment.systemPackages = [ pkgs.sgdboop ]; # Setting SteamGridDB art easier

    boot.kernel.sysctl."vm.max_map_count" = 2147483642; # Some Steam games like this, idk why
  };
}
