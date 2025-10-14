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
        userName = "jamie";
        userEmail = "${"git"}@${"skilet.ro"}"; # bit of scrambling so it cant b scraped as easily
        diff-so-fancy.enable = true;
        ignores = [
          ".DS_Store"
          "**/.DS_Store"
          ".direnv/"
        ];
        extraConfig = {
          pull.rebase = true;
          push.autoSetupRemote = true;
        };
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
          git = {
            paging.pager = "diff-so-fancy";
          };
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
