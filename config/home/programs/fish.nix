{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.erebus.programs.fish.enable = lib.mkEnableOption "Fish shell configuration";

  config = lib.mkIf config.erebus.programs.fish.enable {
    programs.fish = {
      enable = true;
      interactiveShellInit =
        # fish
        ''
          set fish_greeting # disable prompt

          ulimit -n 10240 # increase file descriptor limit

          function starship_transient_prompt_func
            ${lib.getExe config.programs.starship.package} module character
          end

          ${lib.getExe pkgs.nix-your-shell} fish | source
        '';

      shellAbbrs.n = "cd ~/Projects/erebus";
    };

    # prompt
    programs.starship = {
      enable = true;
      enableTransience = true;
      settings = {
        character = {
          success_symbol = "[](bold purple)";
          error_symbol = "[](bold red)";
        };
        nix_shell = {
          symbol = "";
          impure_msg = "";
          heuristic = true;
        };
      };
    };
  };
}
