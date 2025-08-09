{
  inputs,
  lib,
  config,
  ...
}: {
  imports = [inputs.zen.homeModules.twilight];

  options.erebus.programs.zen.enable = lib.mkEnableOption "Zen Browser";

  config = lib.mkIf config.erebus.programs.zen.enable {
    programs.zen-browser = {
      enable = true;
      policies = {
        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;
        DisableAppUpdate = true;
        DisableFeedbackCommands = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DontCheckDefaultBrowser = true;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
      };
      profiles."default" = {}; # TODO: Declare extensions
    };

    # stylix.targets.zen-browser.profileNames = lib.singleton "default"; # TODO
  };
}
