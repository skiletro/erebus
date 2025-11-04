{config, ...}: {
  services.radicale = {
    enable = true;
    settings = {
      server.hosts = [ "127.0.0.1:5232" "[::]:5232" ];
      auth = {
        htpasswd_filename = config.sops.secrets.radicale-users.path;
        htpasswd_encryption = "plain";
      };
    };
  };

  sops.secrets."radicale-users" = {
    owner = "radicale";
    group = "radicale";
  };

  services.caddy.virtualHosts."radicale.warm.vodka".extraConfig = ''
    redir /radicale /radicale/
    handle /radicale/* {
      uri strip_prefix /radicale
      reverse_proxy localhost:5232 {
        header_up X-Script-Name /radicale
        header_up Authorization {header.Authorization}
      }
    }
  '';
}
