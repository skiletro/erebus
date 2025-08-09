{
  lib,
  config,
  self,
  pkgs,
  ...
}: {
  imports = [self.homeModules.disblock];

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
        themeLinks = [
          "https://chloecinders.github.io/visual-refresh-compact-title-bar/browser.css"
          "https://raw.githubusercontent.com/Krammeth/css-snippets/refs/heads/main/PopoutsRevamped.css"
        ];
        plugins = {
          betterGifPicker.enable = true;
          crashHandler.enable = true;
          fakeNitro.enable = true;
          favoriteGifSearch.enable = true;
          fixSpotifyEmbeds.enable = true;
          fixYoutubeEmbeds.enable = true;
          noSystemBadge.enable = true;
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

    xdg.configFile."discord/settings.json".source = (pkgs.formats.json {}).generate "discord-settings.json" {
      DANGEROUS_ENABLE_DEVTOOLS_ONLY_ENABLE_IF_YOU_KNOW_WHAT_YOURE_DOING = true; # i haven't a clue what i'm doing
      offloadAdmControls = false;
      chromiumSwitches = {};
      SKIP_HOST_UPDATE = true;
      trayBalloonShown = true;
      openasar = {
        setup = true;
        quickstart = true;
      };
    };

    xdg.autostart.entries =
      config.lib.erebus.autostartEntry
      "Discord Silent"
      "discord --start-minimized";
  };
}
