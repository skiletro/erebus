{
  config,
  lib,
  pkgs,
  inputs,
  inputs',
  ...
}: {
  options.erebus.programs.steam.enable = lib.mkEnableOption "Steam and Steam tools";

  config = lib.mkIf config.erebus.programs.steam.enable {
    programs.steam = {
      enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin # GloriousEggroll
        steam-play-none # Allows you to run a game without Proton if it is otherwise forced.
        inputs'.cachy-proton.packages.proton-cachyos # Proton-CachyOS, optimised a bit better
      ];
      extest.enable = true;
      protontricks.enable = true;
    };

    home-manager.sharedModules = lib.singleton (userAttrs: {
      imports = [inputs.steam-config-nix.homeModules.default];

      programs.steam.config = {
        enable = true;
        closeSteam = true;
      };

      xdg.autostart.entries = userAttrs.config.lib.erebus.autostartEntry "Steam Silent" "${lib.getExe config.programs.steam.package} -silent -console";
    });

    environment.systemPackages = [pkgs.sgdboop]; # Setting SteamGridDB art easier

    boot.kernel.sysctl."vm.max_map_count" = 2147483642; # Some Steam games like this, idk why
  };
}
