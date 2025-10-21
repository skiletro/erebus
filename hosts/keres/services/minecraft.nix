{ inputs, pkgs, ... }:
{
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];

  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;
    servers.bta-1 = {
      enable = true;
      jvmOpts = "-Xmx2G -Xms2G";
      package = pkgs.minecraftServers.vanilla-1_3.overrideAttrs rec {
        pname = "bta";
        version = "7.3_04";
        src = pkgs.fetchurl {
          url = "https://github.com/Better-than-Adventure/bta-download-repo/releases/download/v${version}/bta.v${version}.server.jar";
          sha256 = "0ry7vhvv0ldprx1as1p5gw9k44agzgcil3f2ld9ck3ayffdm1j3v";
        };
      };
    };
  };
}
