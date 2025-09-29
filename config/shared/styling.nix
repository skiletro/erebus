{
  self',
  pkgs,
  config,
  lib,
  ...
}:
{
  stylix = {
    enable = true;
    base16Scheme = "${self'.packages.base16-schemes-unstable}/share/themes/penumbra-dark-contrast-plus-plus.yaml";
    polarity = "dark";
    image =
      let
        wallpaper = pkgs.fetchurl {
          url = "https://w.wallhaven.cc/full/j5/wallhaven-j5v28q.jpg";
          sha256 = "0xma13kyrdl2mnm67j7g9hkapfw973nqz1527r7azh351ja1rfpr";
        };
      in
      pkgs.runCommand "output.png" { }
        "${lib.getExe pkgs.lutgen} apply ${wallpaper} -o $out -- ${builtins.concatStringsSep " " config.lib.stylix.colors.toList}";
    fonts = {
      sansSerif = {
        package = pkgs.work-sans;
        name = "Work Sans";
      };
      serif = config.stylix.fonts.sansSerif; # Set serif font to the same as the sans-serif
      monospace = {
        package = self'.packages.liga-sfmono-nerd-font;
        name = "Liga SFMono Nerd Font";
      };
      emoji = {
        package = self'.packages.apple-emoji;
        name = "Apple Color Emoji";
      };

      sizes = {
        applications = 10;
        desktop = 10;
        popups = 10;
        terminal = 12;
      };
    };
  };
}
