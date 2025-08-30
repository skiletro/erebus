{
  inputs,
  lib,
  config,
  ...
}:
{
  imports = [ inputs.diffy.nixosModules.tty1Autologin ];

  options.erebus.system.autologin.enable = lib.mkEnableOption "autologin user 'jamie'";

  config = lib.mkIf config.erebus.system.autologin.enable {
    # services.tty1Autologin = {
    #   enable = true;
    #   user = "jamie";
    # };

    services.displayManager.autoLogin = {
      enable = true;
      user = "jamie";
    };
  };
}
