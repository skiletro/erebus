{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.erebus.programs.wakatime.enable = lib.mkEnableOption "WakaTime";

  config = lib.mkIf config.erebus.programs.wakatime.enable {
    home.packages = [ pkgs.wakatime-cli ];

    home.file.".wakatime.cfg" = {
      source = (pkgs.formats.ini { }).generate ".wakatime.cfg" {
        settings = {
          api_url = "https://wt.warm.vodka";
          api_key_vault_cmd = "cat ${config.sops.secrets.wakapi-key.path}";
        };
      };
      force = true;
    };

    sops.secrets."wakapi-key" = { };
  };
}
