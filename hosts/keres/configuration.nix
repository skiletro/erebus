{ pkgs, ... }:
{
  imports = [ ./hardware.nix ];

  boot.kernelPackages = pkgs.linuxPackages_zen;

  erebus.profiles.base.enable = true;

  environment.systemPackages = [ pkgs.ghostty.terminfo ];

  services.caddy = {
    enable = true;
    virtualHosts."violet.fyi".extraConfig = ''
      reverse_proxy :3000
    '';
  };

  services.karakeep = {
    enable = true;
    extraEnvironment = {
      PORT = "3000";
      DISABLE_SIGNUPS = "true";
      DISABLE_NEW_RELEASE_CHECK = "true";
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  system.stateVersion = "25.05";
}
