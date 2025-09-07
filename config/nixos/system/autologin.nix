{
  inputs,
  lib,
  config,
  ...
}:
{
  imports = [ inputs.diffy.nixosModules.tty1Autologin ];

  options.erebus.system.autologin.enable = lib.mkEnableOption "autologin user 'jamie'";

  config =
    let
      enable = true;
      user = "jamie";
    in
    lib.mkIf config.erebus.system.autologin.enable {
      services.tty1Autologin = {
        inherit enable user;
      };

      services.displayManager.autoLogin = {
        inherit enable user;
      };
    };
}
