{
  config,
  lib,
  inputs',
  ...
}:
{
  options.erebus.services.vicinae.enable = lib.mkEnableOption "Vicinae";

  config = lib.mkIf config.erebus.services.vicinae.enable {
    programs.vicinae = {
      enable = true;
      systemd.enable = true;
      extensions = with inputs'.vicinae-extensions.packages; [
        # keep-sorted start
        bluetooth
        # TODO: fuzzy-files (requires goldfish which isnt packaged rn)
        nix
        # keep-sorted end
      ];
    };
  };
}
