{ pkgs, inputs, ... }:
{
  imports = with inputs; [
    disko.nixosModules.default
    nix-minecraft.nixosModules.minecraft-servers
  ];

  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

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

      "karakeep.violet.fyi".extraConfig = ''
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

  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;
    servers.fabric = {
      enable = true;

      # Specify the custom minecraft server package
      package = pkgs.fabricServers.fabric-1_21_8;

      symlinks = {
        mods = pkgs.linkFarmFromDrvs "mods" (
          builtins.attrValues {
            Fabric-API = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/CF23l2iP/fabric-api-0.133.4%2B1.21.8.jar";
              sha512 = "";
            };
            Distant-Horizons = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/uCdwusMi/versions/9yaYzpcr/DistantHorizons-2.3.4-b-1.21.8-fabric-neoforge.jar";
              sha256 = "";
            };
          }
        );
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  system.stateVersion = "25.05";
}
