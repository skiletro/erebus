{ config, lib, ... }:
{
  options.erebus.services.tailscale.enable = lib.mkEnableOption "Tailscale";

  config = lib.mkIf config.erebus.services.tailscale.enable {
    services.tailscale.enable = true;
  };
}
