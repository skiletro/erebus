{
  pkgs,
  lib,
  ...
}: {
  # TODO: Make this less crude. Currently there is no way to run zsh.
  # Probabyl make it so Ghostty runs fish as a command on startup,
  # instead of having it embedded in the .zshrc?
  programs.zsh = {
    promptInit = let
      fish = lib.getExe pkgs.fish;
    in ''
      [ -x ${fish} ] && SHELL=${fish} exec ${fish}
    '';
  };
}
