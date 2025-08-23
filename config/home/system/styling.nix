{
  pkgs,
  lib,
  config,
  self',
  ...
}: {
  options.erebus.system.styling.enable = lib.mkEnableOption "Styling (more limited than NixOS settings)";

  config = lib.mkIf config.erebus.system.styling.enable {
    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
      fonts = {
        sansSerif = {
          package = pkgs.aporetic-bin;
          name = "Aporetic Sans";
        };
        serif = config.stylix.fonts.sansSerif; # Set serif font to the same as the sans-serif
        monospace = {
          package = pkgs.nerd-fonts.zed-mono;
          name = "ZedMono Nerd Font";
        };
        emoji = lib.mkIf pkgs.stdenvNoCC.hostPlatform.isLinux {
          package = self'.packages.apple-emoji;
          name = "Apple Color Emoji";
        };
        sizes.terminal = lib.mkIf pkgs.stdenvNoCC.hostPlatform.isDarwin 16; # need to account for HiDPI Mac displays
      };
    };
  };
}
