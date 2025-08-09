{
  # options.erebus.system.nix.enable = lib.mkEnableOption "Nix options";
  config.nixpkgs.config.allowUnfree = true;
}
