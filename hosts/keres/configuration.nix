{ pkgs, ... }:
{
  imports = [ ./hardware.nix ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  erebus.profiles.base.enable = true;

  environment.systemPackages = [ pkgs.ghostty.terminfo ];

  services.caddy = {
    enable = true;
    virtualHosts = {
      "violet.fyi".extraConfig = ''
        	header Content-Type text/html
        	respond <<HTML
        		<html>
        			<body><a href="https://kerakeep.violet.fyi">kerakeep</a></body>
        		</html>
        		HTML 200
      '';

      "kerakeep.violet.fyi".extraConfig = ''
        reverse_proxy :3000
      '';
    };
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
