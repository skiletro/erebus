{
  self,
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [ self.homeModules.pwa ];

  options.erebus.programs.pwa.enable = lib.mkEnableOption "Progressive Web Apps";

  config = lib.mkIf config.erebus.programs.pwa.enable {
    programs.firefoxpwa = {
      enable = true;
      webapps = {
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
          icon = pkgs.fetchurl {
            url = "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e7/Instagram_logo_2016.svg/1920px-Instagram_logo_2016.svg.png";
            sha256 = "02fd9v778x91b2i2ywhj50lfsqzax5fkc723npzbmh990l80cwjm";
          };
        };
      };
    };
  };
}
