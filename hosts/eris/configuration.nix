{
  erebus = {
    system = {
      boot.enable = true;
      locale.enable = true;
      user.enable = true;
    };

    desktop.gnome.enable = true;
  };

  home-manager.sharedModules = [
    {
      erebus.programs = {
        discord.enable = true;
        ghostty.enable = true;
      };
    }
  ];
}
