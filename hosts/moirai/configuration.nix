{
  erebus = {
    system.user.enable = true;
  };

  home-manager.sharedModules = [
    {
      erebus.programs.helix.enable = true;
      erebus.system.styling.enable = true;
      erebus.programs.ghostty.enable = true;
    }
  ];

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };

  system.stateVersion = 6; # do not change
}
