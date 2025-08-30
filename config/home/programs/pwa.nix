{
  self,
  lib,
  config,
  ...
}:
{
  imports = [ self.homeModules.pwa ];

  options.erebus.programs.pwa.enable = lib.mkEnableOption "Progressive Web Apps";

  config = lib.mkIf config.erebus.programs.pwa.enable {
    programs.firefoxpwa = {
      enable = true;
      webapps = {
        "Proton Mail" = {
          url = "https://mail.proton.me";
          manifestUrl = "https://mail.proton.me/manifest.json";
          categories = [
            "Office"
            "Network"
            "Email"
          ];
          icon = "proton-mail";
        };
        "WhatsApp" = {
          url = "https://web.whatsapp.com";
          manifestUrl = "https://web.whatsapp.com/manifest.json";
          categories = [ "Network" ];
          icon = "whatsapp";
        };
        "Instagram" = {
          url = "https://instagram.com";
          manifestUrl = "https://instagram.com/manifest.json";
          categories = [ "Network" ];
          icon = "facebook-messenger";
        };
      };
    };
  };
}
