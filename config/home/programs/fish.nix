{
  config,
  lib,
  pkgs,
  ...
}: {
  options.erebus.programs.fish.enable = lib.mkEnableOption "Fish shell configuration";

  config = lib.mkIf config.erebus.programs.fish.enable {
    programs.fish = {
      enable = true;
      interactiveShellInit =
        # fish
        ''
          set fish_greeting # disable prompt

          function starship_transient_prompt_func
            ${lib.getExe config.programs.starship.package} module character
          end

          ${lib.getExe pkgs.nix-your-shell} fish | source
        '';
      functions = {
        "," =
          # fish
          ''
            if test (count $argv) -lt 1
              echo "Usage: , <pkg> [extraArgs]"
            else
              NIXPKGS_ALLOW_UNFREE=1 nix run "nixpkgs#$argv[1]" --impure -- $argv[2..-1]
            end
          '';

        ":" =
          # fish
          ''
            if test (count $argv) -lt 1
              echo "Usage: : <pkg1> [<pkg2> ... <pkgN>]"
            else if test (count $argv) -eq 1
              nix shell nixpkgs#$argv[1]
            else
              set args
              for arg in $argv
                set args $args "nixpkgs#$arg"
              end
              NIXPKGS_ALLOW_UNFREE=1 nix shell $args --impure
            end
          '';
      };

      shellAbbrs.n = "cd ~/.nix_config/";
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
