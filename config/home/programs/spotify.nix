{
  pkgs,
  inputs,
  inputs',
  lib,
  config,
  ...
}:
{
  imports = [ inputs.spicetify.homeManagerModules.default ];

  options.erebus.programs.spotify.enable = lib.mkEnableOption "Spotify and Spicetify addons";

  config = lib.mkIf config.erebus.programs.spotify.enable {
    stylix.targets.spicetify.enable = false; # The default spicetify theme colours kinda suck

    programs.spicetify =
      let
        inherit (inputs'.spicetify.legacyPackages) extensions apps;
      in
      {
        enable = true;

        enabledExtensions = with extensions; [
          songStats
        ];

        enabledCustomApps = with apps; [
          newReleases
          lyricsPlus
        ];

        theme = {
          name = "stylix";
          src = pkgs.writeTextFile {
            name = "color.ini";
            destination = "/color.ini";
            text = with config.lib.stylix.colors; ''
              [base]
              text               = ${base05}
              subtext            = ${base05}
              main               = ${base00}
              main-elevated      = ${base02}
              highlight          = ${base02}
              highlight-elevated = ${base03}
              sidebar            = ${base01}
              player             = ${base02}
              card               = ${base00}
              shadow             = ${base00}
              selected-row       = ${base05}
              button             = ${base0B}
              button-active      = ${base05}
              button-disabled    = ${base03}
              tab-active         = ${base0B}
              notification       = ${base0B}
              notification-error = ${base08}
              equalizer          = ${base0B}
              misc               = ${base00}
            '';
          };
          # Sidebar configuration is incompatible with the default navigation bar
          sidebarConfig = false;
        };
        colorScheme = "base";
      };
  };
}
