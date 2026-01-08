{
  lib,
  config,
  pkgs,
  self',
  ...
}:
{
  options.erebus.profiles.gaming.enable =
    lib.mkEnableOption "gaming related *stuff*. This includes VR.";

  config = lib.mkIf config.erebus.profiles.gaming.enable {
    erebus = {
      programs = {
        gamemode.enable = true;
        gsr.enable = true;
        steam.enable = true;
        wivrn.enable = true;
      };

      services = {
        sunshine.enable = true;
      };
    };

    environment.systemPackages = with pkgs; [
      # keep-sorted start ignore_prefixes=self'.packages.
      bs-manager
      dolphin-emu
      self'.packages.dzgui
      heroic
      lsfg-vk
      lsfg-vk-ui # frame gen
      ludusavi
      osu-lazer-bin
      r2modman
      ryubing # switch emu
      vrcx
      self'.packages.wheelwizard
      # keep-sorted end
    ];

    home-manager.sharedModules = lib.singleton (userAttrs: {
      erebus.programs.prismlauncher.enable = true;
      programs.mangohud.enable = true;

      xdg.autostart.entries = userAttrs.config.lib.erebus.autostartEntry "VRCX Silent" "${lib.getExe' pkgs.vrcx "vrcx"} --startup";
    });
  };
}
