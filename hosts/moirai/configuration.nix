{
  erebus = {
    system.user.enable = true;
  };

  home-manager.sharedModules = [
    {
      erebus.programs = {
        bat.enable = true;
        direnv.enable = true;
        eza.enable = true;
        fastfetch.enable = true;
        fish.enable = true;
        ghostty.enable = true;
        git.enable = true;
        helix.enable = true;
        yazi.enable = true;
        spotify.enable = true;
        zen.enable = true;
      };
    }
  ];

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };

  system.stateVersion = 6; # do not change
}
