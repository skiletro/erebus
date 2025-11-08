{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.erebus.programs.git.enable = lib.mkEnableOption "Git and git tooling";

  config = lib.mkIf config.erebus.programs.git.enable {
    programs = {
      git = {
        enable = true;
        ignores = [
          ".DS_Store"
          "**/.DS_Store"
          ".direnv/"
        ];
        settings = {
          user = {
            name = "jamie";
            email = "${"git"}@${"skilet.ro"}"; # bit of scrambling so it cant b scraped as easily
          };
          pull.rebase = true;
          push.autoSetupRemote = true;
        };
      };

      diff-so-fancy = {
        enable = true;
        enableGitIntegration = true;
      };

      lazygit = {
        enable = true;
        settings = {
          gui = {
            nerdFontsVersion = "3";
            spinner.frames = [
              "⠟"
              "⠯"
              "⠷"
              "⠾"
              "⠽"
              "⠻"
            ];
          };
          git.pagers = [
            {
              pager = "diff-so-fancy";
            }
          ];
          disableStartupPopups = true;
        };
      };
      fish.shellAbbrs.lg = "lazygit";
    };

    home.packages = with pkgs; [
      gh # github
      codeberg-cli # codeberg
    ];
  };
}
