{ lib, ... }:
let
  inherit (lib) mkForce;
in
{
  erebus = {
    profiles = {
      base.enable = true;
      gaming.enable = true;
      graphical.enable = true;
      terminal.enable = true;
    };

    # I am aware that these programs do work, however they are quite heavy
    # to keep in a virtual machine.
    programs = {
      steam.enable = mkForce false;
    };

    system.autologin.enable = true; # It's getting annoying typing in the pwd
  };

  home-manager.sharedModules = lib.singleton { erebus.programs.discord.enable = mkForce false; };
}
