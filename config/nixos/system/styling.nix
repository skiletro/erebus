{
  self,
  pkgs,
  ...
}: {
  imports = [self.nixosModules.styling];

  erebus.system.styling = {
    enable = true;
    colorScheme = "catppuccin-mocha";
    wallpaper = pkgs.fetchurl {
      url = "https://w.wallhaven.cc/full/13/wallhaven-13reow.png";
      sha256 = "1lns86p10wqnnx4h3lcr08p323c7s5n5mkzgz941anm21gja1ngh";
    };
  };
}
