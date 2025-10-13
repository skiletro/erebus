{ config, ... }:
{
  services.caddy = {
    enable = true;
    virtualHosts = {
      "warm.vodka" = {
        serverAliases = [
          "www.warm.vodka"
          "warm.vodka"
        ];
        extraConfig = ''
          header Content-Type text/html
          respond "are you a fan of warm vodka?"
        '';
      };

      "kk.warm.vodka".extraConfig = ''
        reverse_proxy :${config.services.karakeep.extraEnvironment.PORT}
      '';

      "f.warm.vodka".extraConfig = ''
        reverse_proxy :${config.services.copyparty.settings.p}
      '';
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
