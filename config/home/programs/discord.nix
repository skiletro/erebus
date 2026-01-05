{
  lib,
  config,
  self,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenvNoCC.hostPlatform) isLinux;
  ifLinux = bool: if isLinux then bool else !bool;
in
{
  imports = [ self.homeModules.disblock ];

  options.erebus.programs.discord.enable = lib.mkEnableOption "Discord (+ Nixcord/Vencord)";

  config = lib.mkIf config.erebus.programs.discord.enable {
    programs.nixcord = {
      enable = true;
      discord = {
        enable = ifLinux false;
        vencord.enable = false;
        equicord.enable = ifLinux true;
      };
      equibop = {
        enable = true;
        autoscroll.enable = true;
        package = pkgs.equibop.overrideAttrs (_oldAttrs: {
            postBuild = ''
              pushd build
              ${lib.getExe pkgs.python313Packages.icnsutil} e icon.icns
              popd
            '';

            installPhase = ''
              runHook preInstall
              mkdir -p $out/opt/Equibop
              cp -r dist/*unpacked/resources $out/opt/Equibop/

              for file in build/icon.icns.export/*\@2x.png; do
                base=''${file##*/}
                size=''${base/x*/}
                targetSize=$((size * 2))
                install -Dm0644 $file $out/share/icons/hicolor/''${targetSize}x''${targetSize}/apps/equibop.png
              done

              runHook postInstall
            '';
          });
      };
      config = {
        useQuickCss = true;
        themeLinks = lib.optional pkgs.stdenvNoCC.hostPlatform.isLinux "https://chloecinders.github.io/visual-refresh-compact-title-bar/hidden.css";
        plugins = {
          betterGifPicker.enable = true;
          clearUrLs.enable = true;
          crashHandler.enable = true;
          fakeNitro.enable = true;
          favoriteGifSearch.enable = true;
          fixSpotifyEmbeds.enable = true;
          fixYoutubeEmbeds.enable = true;
          limitMiddleClickPaste.enable = true;
          listenBrainzRpc = {
            enable = true;
            hideWithSpotify = true;
            username = "skiletro";
          };
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

    xdg.autostart.entries = lib.mkIf isLinux (
      config.lib.erebus.autostartEntry "Discord Silent" "${lib.getExe config.programs.nixcord.finalPackage.equibop} --start-minimized"
    );
  };
}
