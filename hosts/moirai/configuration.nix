{ pkgs, ... }:
{
  erebus = {
    system.user.enable = true;
  };

  home-manager.sharedModules = [
    {
      erebus.programs = {
        bat.enable = true;
        direnv.enable = true;
        discord.enable = true;
        eza.enable = true;
        fastfetch.enable = true;
        fish.enable = true;
        ghostty.enable = true;
        git.enable = true;
        helix.enable = true;
        yazi.enable = true;
        spotify.enable = true;
        zen.enable = true;
        prismlauncher.enable = true;
      };
    }
  ];

  environment.systemPackages = with pkgs; [ utm ];

  system.stateVersion = 6; # do not change
}
