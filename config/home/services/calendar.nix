{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.erebus.services.calendar.enable =
    lib.mkEnableOption "calendar syncing with khal and vdirsyncer";

  config = lib.mkIf config.erebus.services.calendar.enable {
    sops.secrets."proton-calendar-url" = { };

    accounts.calendar = {
      basePath = ".calendars";

      accounts.proton = {
        khal = {
          enable = true;
          readOnly = true;
        };
        remote.type = "http";
        vdirsyncer = {
          enable = true;
          # i should probably get shot for this horrendous abomination.
          urlCommand = lib.singleton (pkgs.writeShellScript "fetch-vdirsyncer-url" "cat ${config.sops.secrets.proton-calendar-url.path}")
          .outPath;
        };
      };
    };

    programs = {
      khal.enable = true;
      vdirsyncer.enable = true;
    };

    services.vdirsyncer.enable = lib.mkIf pkgs.stdenvNoCC.hostPlatform.isLinux true;
  };
}
