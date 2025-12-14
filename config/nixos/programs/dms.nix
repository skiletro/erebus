{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.erebus.programs.dms.enable = lib.mkEnableOption "Dank Material Shell";

  config = lib.mkIf config.erebus.programs.dms.enable {
    programs.dms-shell = {
      enable = true;
      enableDynamicTheming = false; # we use stylix instead
      systemd.target = "wayland-session.target";
    };

    home-manager.sharedModules = [
      {
        erebus.services.calendar.enable = true;

        home.packages = with pkgs; [
          dgop
          dsearch
        ];

        home.file =
          let
            dmsPath = ".config/DankMaterialShell";

            colorTheme = with config.lib.stylix.colors.withHashtag; {
              dark = {
                name = "Stylix generated dark theme";
                primary = base0D;
                primaryText = base00;
                primaryContainer = base0C;
                secondary = base0E;
                surface = base01;
                surfaceText = base05;
                surfaceVariant = base02;
                surfaceVariantText = base04;
                surfaceTint = base0D;
                background = base00;
                backgroundText = base05;
                outline = base03;
                surfaceContainer = base01;
                surfaceContainerHigh = base02;
                surfaceContainerHighest = base03;
                error = base08;
                warning = base0A;
                info = base0C;
              };

              light = {
                name = "Stylix generated light theme";
                primary = base0D;
                primaryText = base07;
                primaryContainer = base0C;
                secondary = base0E;
                surface = base06;
                surfaceText = base01;
                surfaceVariant = base07;
                surfaceVariantText = base02;
                surfaceTint = base0D;
                background = base07;
                backgroundText = base00;
                outline = base04;
                surfaceContainer = base06;
                surfaceContainerHigh = base05;
                surfaceContainerHighest = base04;
                error = base08;
                warning = base0A;
                info = base0C;
              };
            };
          in
          {
            "${dmsPath}/stylix-colors.json".text = builtins.toJSON colorTheme;
            "${dmsPath}/plugins/emojiPicker" = {
              recursive = true;
              source = pkgs.fetchFromGitHub {
                owner = "devnullvoid";
                repo = "dms-emoji-launcher";
                rev = "2951ec7f823c983c11b6b231403581a386a7c9f6";
                sha256 = "sha256-aub5pXRMlMs7dxiv5P+/Rz/dA4weojr+SGZAItmbOvo=";
              };
            };
          };
      }
    ];
  };
}
