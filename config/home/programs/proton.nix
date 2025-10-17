{
  lib,
  config,
  pkgs,
  self',
  ...
}:
{
  options.erebus.programs.proton.enable =
    lib.mkEnableOption "Proton suite of apps: Proton Mail, Proton Pass, etc.";

  config = lib.mkIf config.erebus.programs.proton.enable {
    home.packages =
      if pkgs.stdenvNoCC.hostPlatform.isDarwin then
        (with self'.packages; [
          protonmail-bin
          protonpass-bin
          protonvpn-bin
        ])
      else
        (with pkgs; [
          protonmail-desktop
          proton-pass
          protonvpn-gui
        ]);
  };
}
