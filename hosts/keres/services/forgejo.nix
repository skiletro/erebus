{
  lib,
  config,
  ...
}:
{
  services.forgejo = {
    enable = true;
    lfs.enable = true;
    settings = {
      server = {
        DOMAIN = "git.warm.vodka";
        ROOT_URL = "https://git.warm.vodka/";
        HTTP_PORT = 3003;
      };
      service.DISABLE_REGISTRATION = true;
    };
  };

  sops.secrets.forgejo-jamie-password.owner = "forgejo";

  systemd.services.forgejo.preStart =
    let
      forgejo = lib.getExe config.services.forgejo.package;
      user = "jamie";
      passwordPath = config.sops.secrets-forgejo-jamie-password.path;
    in
    ''
      ${forgejo} admin user create \
      --admin \
      --username ${user} \
      --password "$(tr -d '\n' < ${passwordPath})" \
      || true # necessary so doesnt fail if user exists

      ${forgejo} admin user change-password \
      --username ${user} \
      --password "$(tr -d '\n' < ${passwordPath})" \
      || true
    '';

  services.caddy.virtualHosts."git.warm.vodka".extraConfig = ''
    reverse_proxy :${toString config.services.forgejo.settings.server.HTTP_PORT}
  '';
}
