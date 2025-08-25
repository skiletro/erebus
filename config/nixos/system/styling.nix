{
  self,
  pkgs,
  ...
}: {
  imports = [self.nixosModules.styling];

  erebus.system.styling = {
    enable = true;
    colorScheme = "penumbra-dark-contrast-plus-plus";
    wallpaper = pkgs.fetchurl {
      url = "https://w.wallhaven.cc/full/qz/wallhaven-qzrgg5.jpg";
      sha256 = "0c7cfx3c71dcpdmncc66v2v2kvf2fd2rbl41xpjgazxgkl6w6c2k";
    };
  };
}
