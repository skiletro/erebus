{
  lib,
  config,
  self,
  pkgs,
  ...
}:
{
  imports = [ self.homeModules.disblock ];

  options.erebus.programs.discord.enable = lib.mkEnableOption "Discord (+ Nixcord/Vencord)";

  config = lib.mkIf config.erebus.programs.discord.enable {
    programs.nixcord = {
      enable = true;
      discord = {
        enable = true;
        autoscroll.enable = true;
      };
      config = {
        useQuickCss = true;
        themeLinks = lib.optional pkgs.stdenvNoCC.hostPlatform.isLinux "https://chloecinders.github.io/visual-refresh-compact-title-bar/browser.css";
        plugins = {
          betterGifPicker.enable = true;
          crashHandler.enable = true;
          fakeNitro.enable = true;
          favoriteGifSearch.enable = true;
          fixSpotifyEmbeds.enable = true;
          fixYoutubeEmbeds.enable = true;
          noSystemBadge.enable = true;
          messageLogger.enable = true;
          openInApp.enable = true;
          serverInfo.enable = true;
          unindent.enable = true;
          youtubeAdblock.enable = true;
        };
      };
    };

    services.disblock = {
      enable = true;
      settings = {
        gif-button = true;
        active-now = false;
        clan-tags = false;
        settings-billing-header = false;
        settings-gift-inventory-tab = false;
      };
    };

    # Under normal circumstances, I'd say to use the lib.getExe stuff to get the proper package,
    # however for some reason if I do that here, my theme and stuff won't activate properly. 🤷
    xdg.autostart.entries = config.lib.erebus.autostartEntry "Discord Silent" "discord --start-minimized";
  };
}
