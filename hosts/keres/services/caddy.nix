{
  services.caddy = {
    enable = true;
    virtualHosts = {
      "warm.vodka" = {
        serverAliases = [
          "www.warm.vodka"
        ];
        extraConfig = ''
          header Content-Type text/html
          respond "are you a fan of warm vodka?"
        '';
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
