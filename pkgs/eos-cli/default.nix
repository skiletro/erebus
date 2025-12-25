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

        def exit-if-darwin [] {
            if $SYSTEM == "darwin" {
                print $"(ansi purple)> (ansi reset)This command is unavailable on darwin systems."
                exit 1
            }
        }

        def main []: nothing -> nothing { help main }

        # rebuild and switch to the new generation
        export def "main switch" --wrapped [...args: string] {
            nix fmt
            git add -A 
            nh $SYSTEM switch -- ...$args
        }

        # rebuild and boot into the new generation
        export def "main boot" --wrapped [...args: string] {
            exit-if-darwin
            nix fmt
            git add -A
            nh $SYSTEM boot -- ...$args
        }

        # build and activate, without adding to bootloader
        export def "main test" --wrapped [...args: string] {
            exit-if-darwin
            nh $SYSTEM test --impure -- ...$args
        }

        # update flake inputs and nvfetcher sources
        export def "main update" [] {
            nix flake update --refresh
            nvfetcher -c ./pkgs/nvfetcher.toml -o ./pkgs/_sources/
        }

        # formats the repo, ready for committing
        export def "main format" [] {
            git add -A
            nix fmt
            git reset
        }

        # open a nix repl for the flake
        export def "main repl" [...args: string] {
            print $"(ansi purple)! (ansi reset):q to quit!"
            nh $SYSTEM repl ...$args
        }

        # garbage-collect and optimise the nix store
        export def "main clean" [] {
            nh clean all -K 1d
            nix store optimise
        }

        # verify and repair the nix store
        export def "main repair" [] {
            nix-store --verify --check-contents --repair
        }
      '';
in
writeBashBin "eos" ''
  cd ${flakeLocation}
  export NH_FLAKE=${flakeLocation}
  exec ${lib.getExe nuScript} "$@"
''
