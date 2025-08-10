{
  config,
  lib,
  pkgs,
  ...
}: {
  options.erebus.programs.fish.enable = lib.mkEnableOption "setting Fish shell as default, alongside other configuration";

  config = lib.mkIf config.erebus.programs.fish.enable {
    programs.fish.enable = true; # For autocompletions. We will use the home manager module for configuration.

    # Set as default shell. See https://wiki.nixos.org/wiki/Fish#Setting_fish_as_default_shell
    programs.bash.interactiveShellInit = ''
      if [[ $(${lib.getExe' pkgs.procps "ps"} --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${lib.getExe pkgs.fish} $LOGIN_OPTION
      fi
    '';

    home-manager.sharedModules = lib.singleton {
      programs.fish = {
        enable = true;
        interactiveShellInit = ''
          set fish_greeting
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

          "process_replays" =
            # fish
            ''
              for file in Replay_*.mp4
                set output Processed_$file
                ffmpeg -i $file $output
              end
            '';
        };

        shellAbbrs.n = "cd ~/.nix_config/";
      };
    };
  };
}
