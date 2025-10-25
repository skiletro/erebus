{ self, ... }:
{
  imports = [ self.nixosModules.snac2 ];

  services.snac2.enable = true;

  services.caddy.virtualHosts."fedi.warm.vodka".extraConfig = ''
    reverse_proxy :3004
  '';
}
