{ pkgs, lib, ... }:
let
  inherit (pkgs.writers) writeNuBin writeBashBin;
  flakeLocation = "~/Projects/erebus";
  nuScript =
    writeNuBin "eos" # nu
      ''
        alias git = ${lib.getExe pkgs.git};
        alias nh = ${lib.getExe pkgs.nh};
        alias nvfetcher = ${lib.getExe pkgs.nvfetcher};
          
        const SYSTEM = (if ($nu.os-info.name | str downcase) == "macos" { "darwin" } else { "os" })

        def nh_sys [goal: string, ...args: string] {
            nh $SYSTEM $goal -- ...$args
        }

        def cd-to-flake [] {
            cd ("${flakeLocation}" | path expand)
        }

        def main []: nothing -> nothing { help main }

        # rebuild and switch to the new generation
        export def "main switch" --wrapped [...args: string] {
            cd-to-flake
            nix fmt
            git add -A 
            nh_sys switch ...$args
        }

        # rebuild and boot into the new generation
        export def "main boot" --wrapped [...args: string] {
            cd-to-flake
            nix fmt
            git add -A
            nh_sys boot ...$args
        }

        # build the configuration without activating it
        export def "main test" --wrapped [...args: string] {
            cd-to-flake
            nix fmt
            git add -A
            nh_sys test ...$args
        }

        # update flake inputs and nvfetcher sources
        export def "main update" [input?: string] {
            cd-to-flake
            nix flake update ...($input | default []) --refresh
            nvfetcher -c ./pkgs/nvfetcher.toml -o ./pkgs/_sources/
        }

        # open a nix repl for the flake
        export def "main repl" [...args: string] {
            cd-to-flake
            print $"(ansi purple)! (ansi reset):q to quit!"
            nh_sys repl ...$args
        }

        # garbage-collect and optimise the nix store
        export def "main clean" [] {
            cd-to-flake
            nh clean all -K 1d
            nix store optimise
        }

        # verify and repair the nix store
        export def "main repair" [] {
            cd-to-flake
            nix-store --verify --check-contents --repair
        }
      '';
in
writeBashBin "eos" ''
  cd ~/Projects/erebus
  export NH_FLAKE=${flakeLocation}
  exec ${lib.getExe nuScript} "$@"
''
