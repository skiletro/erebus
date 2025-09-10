{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.erebus.programs.git.enable = lib.mkEnableOption "Git and git tooling";

  config = lib.mkIf config.erebus.programs.git.enable {
    # See https://github.com/uncenter/flake/blob/main/user/programs/git.nix for some options you can steal >:P
    programs = {
      git = {
        enable = true;
        userName = "skiletro";
        userEmail = "19377854+skiletro@users.noreply.github.com";
        diff-so-fancy.enable = true;
        ignores = [ ".DS_Store .envrc" ];
      };

      lazygit = {
        enable = true;
        settings = {
          gui = {
            nerdFontsVersion = "3";
            spinner.frames = [
              "◜"
              "◝"
              "◞"
              "◟"
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

    home.packages = [ pkgs.gh ];
  };
}
