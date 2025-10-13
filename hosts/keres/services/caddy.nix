{config, ...}: {
  services.caddy = {
    enable = true;
    virtualHosts = {
      "warm.vodka" = {
        serverAlises = ["www.warm.vodka" "warm.vodka"];
        extraConfig = ''
          respond "are you a fan of warm vodka?"
        '';
      };
      
      "kk.warm.vodka".extraConfig = ''
        reverse_proxy :${config.services.karakeep.extraEnvironment.PORT}
      '';
    };
  };
}
