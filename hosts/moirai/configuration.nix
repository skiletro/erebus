{
  erebus = {
    profiles = {
      base.enable = true;
      graphical.enable = true;
      terminal.enable = true;
    };
  };

  homebrew.casks = [
    "godot"
    "microsoft-teams" # for work
    "steam"
    "unity-hub"
  ];

  system.stateVersion = 6; # do not change
}
