{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (pkgs.stdenvNoCC.hostPlatform) isLinux;
in
{
  options.erebus.programs.btop.enable = lib.mkEnableOption "btop";

  config = mkIf config.erebus.programs.btop.enable {
    programs.btop = {
      enable = true;
      package = mkIf isLinux pkgs.btop-rocm;
      settings = {
        update_ms = 200;
        show_boxes = "proc cpu mem net gpu0 gpu1 gpu2 gpu3 gpu4 gpu5";
      };
    };
  };
}
