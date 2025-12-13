{ pkgs, lib, ... }:
let
  inherit (pkgs.writers) writeNuBin writeBashBin;
  git = lib.getExe pkgs.git;
  nh = lib.getExe pkgs.nh;
  nvfetcher = lib.getExe pkgs.nvfetcher;
  nuScript =
    writeNuBin "eos-cli" # nu
      ''
        const NH_FLAKE = "~/Projects/erebus/"
        const SYSTEM   = (if ($nu.os-info.name | str downcase) == "macos" { "darwin" } else { "os" })

        def run [cmd: list<string>] {
            let clean = ($cmd | str replace -r '^/nix/store/.*?/bin/' "")
            print $"(ansi purple)> (ansi reset)($clean | str join ' ')"
            ^$cmd
        }

        def nh [goal: string, ...args: string] {
            run [`${nh}` $SYSTEM $goal -- ...$args]
        }

        def cd-to-flake [] {
            cd $NH_FLAKE
        }

        def main []: nothing -> table<name: string, description: string> {
            # print "Available commands:"
            help commands
            | where command_type == custom
            | where name =~ '^main'
            | where name != "main"
            | update name {|v| $v.name | str replace --regex '^main\s+' ""}
            | select name description
            | table -i false --theme compact
        }

        # rebuild and switch to the new generation
        export def "main switch" [...args: string] {
            cd-to-flake
            run [`nix` `fmt`]
            run [`${git}` `add` `.`]
            nh switch ...$args
        }

        # rebuild and boot into the new generation
        export def "main boot" [...args: string] {
            cd-to-flake
            run [`nix` `fmt`]
            run [`${git}` `add` `.`]
            nh boot ...$args
        }

        # build the configuration without activating it
        export def "main test" [...args: string] {
            cd-to-flake
            run [`nix` `fmt`]
            run [`${git}` `add` `.`]
            nh test ...$args
        }

        # update flake inputs and nvfetcher sources
        export def "main update" [input?: string] {
            cd-to-flake
            run [`nix` `flake` `update` ...($input | default []) --refresh]
            run [`${nvfetcher}` `-c` `./pkgs/nvfetcher.toml` `-o` `./pkgs/_sources/`]
        }

        # open a nix repl for the flake
        export def "main repl" [...args: string] {
            cd-to-flake
            print $"(ansi purple)! (ansi reset):q to quit!"
            nh repl ...$args
        }

        # garbage-collect and optimise the nix store
        export def "main clean" [] {
            cd-to-flake
            run [`${nh}` `clean` `all` `-K` `1d`]
            run [`nix` `store` `optimise`]
        }

        # verify and repair the nix store
        export def "main repair" [] {
            cd-to-flake
            run [`nix-store` `--verify` `--check-contents` `--repair`]
        }
      '';
in
writeBashBin "eos" ''
  cd ~/Projects/erebus
  exec ${lib.getExe nuScript} "$@"
''
