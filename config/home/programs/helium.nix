{
  lib,
  config,
  pkgs,
  self',
  ...
}:
let
  inherit (pkgs.stdenvNoCC.hostPlatform) isDarwin;
  inherit (self'.packages) helium-linux helium-macos;
in
{
  options.erebus.programs.helium.enable = lib.mkEnableOption "Helium Browser";

  config = lib.mkIf config.erebus.programs.helium.enable {
    home.packages = [ (if isDarwin then helium-macos else helium-linux) ];
  };
}
