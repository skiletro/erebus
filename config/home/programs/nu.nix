{
  config,
  lib,
  ...
}:
{
  options.erebus.programs.nu.enable = lib.mkEnableOption "Nushell configuration";

  config = lib.mkIf config.erebus.programs.nu.enable {
    programs.nushell = {
      enable = true;
      extraConfig =
        # nu
        ''
          # Carapace completions
          let carapace_completer = {|spans: list<string>|
              carapace $spans.0 nushell ...$spans
              | from json
              | if ($in | default [] | any {|| $in.display | str starts-with "ERR"}) { null } else { $in }
          }

          # Fish completions
          let fish_completer = {|spans|
              fish --command $"complete '--do-complete=($spans | str replace --all "'" "\\'" | str join ' ')'"
              | from tsv --flexible --noheaders --no-infer
              | rename value description
              | update value {|row|
                let value = $row.value
                let need_quote = ['\' ',' '[' ']' '(' ')' ' ' '\t' "'" '"' "`"] | any {$in in $value}
                if ($need_quote and ($value | path exists)) {
                  let expanded_path = if ($value starts-with ~) {$value | path expand --no-symlink} else {$value}
                  $'"($expanded_path | str replace --all "\"" "\\\"")"'
                } else {$value}
              }
          }

          # This completer will use carapace by default
          let external_completer = {|spans|
              let expanded_alias = scope aliases
              | where name == $spans.0
              | get -o 0.expansion

              let spans = if $expanded_alias != null {
                  $spans
                  | skip 1
                  | prepend ($expanded_alias | split row ' ' | take 1)
              } else {
                  $spans
              }

              match $spans.0 {
                  # carapace completions are incorrect for nu
                  nu => $fish_completer
                  # fish completes commits and branch names in a nicer way
                  git => $fish_completer
                  # carapace doesn't have completions for asdf
                  asdf => $fish_completer
                  _ => $carapace_completer
              } | do $in $spans
          }

          $env.config = {
            show_banner: false
            completions: {
              external: {
                enable: true
                completer: $external_completer
              }
            }
          };
        '';
      loginFile.text =
        # nu
        ''
          ulimit -n 10240 # increase file descriptor limit
        '';
    };

    home.shell.enableNushellIntegration = true;

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
