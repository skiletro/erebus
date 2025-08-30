{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.erebus.system.fonts.enable = lib.mkEnableOption "Fonts";

  config = lib.mkIf config.erebus.system.fonts.enable {
    fonts = {
      fontDir.enable = true;

      packages = with pkgs; [
        corefonts # Microsoft Fonts
        vistafonts # More Microsoft Fonts
        noto-fonts
        noto-fonts-extra
        noto-fonts-cjk-sans # Japanese, Korean, Chinese, etc
        noto-fonts-color-emoji
      ];
    };
  };
}
