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
          $env.config = {
            show_banner: false
            completions: {
              external: {
                enable: true
              }
            }
            highlight_resolved_externals: true
          };
        '';
      loginFile.text =
        # nu
        ''
          ulimit -n 10240 # increase file descriptor limit
        '';
      environmentVariables = {

      }
      // (builtins.mapAttrs (_name: value: builtins.toString value) config.home.sessionVariables);
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
