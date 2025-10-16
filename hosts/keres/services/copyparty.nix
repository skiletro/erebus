{ inputs, config, ... }:
{
  imports = [ inputs.copyparty.nixosModules.default ];

  nixpkgs.overlays = [ inputs.copyparty.overlays.default ];

  sops.secrets."copyparty-jamie-password" = {
    owner = "copyparty";
    group = "copyparty";
  };

  sops.secrets."copyparty-mmu-password" = {
    owner = "copyparty";
    group = "copyparty";
  };

  services.copyparty = {
    enable = true;
    user = "copyparty";
    group = "copyparty";
    settings = {
      i = "0.0.0.0";
      p = 3002;
      ban-404 = false;
      ban-403 = false;
    };

    accounts = {
      jamie.passwordFile = config.sops.secrets.copyparty-jamie-password.path;
      mmu.passwordFile = config.sops.secrets.copyparty-mmu-password.path;
    };

    volumes = {
      "/" = {
        path = "/srv/copyparty";
        access.A = "jamie";
      };

      "/public" = {
        path = "/srv/copyparty/public";
        access = {
          A = "jamie";
          r = "*";
        };
        flags.fk = 8;
      };

      "/mmu" = {
        path = "/srv/copyparty/mmu";
        access = {
          A = "jamie";
          r = "*";
          rw = "mmu";
        };
      };
    };
  };

  services.caddy.virtualHosts."f.warm.vodka".extraConfig = ''
    reverse_proxy :${toString config.services.copyparty.settings.p}
  '';
}
