{
  lib,
  config,
  pkgs,
  self',
  ...
}:
{
  options.erebus.profiles.terminal.enable =
    lib.mkEnableOption "terminal applications that are generally wanted on all systems, but aren't required like the `base` profile.";

  config = lib.mkIf config.erebus.profiles.terminal.enable {
    erebus.programs = {
      beets.enable = lib.mkIf pkgs.stdenvNoCC.hostPlatform.isLinux true;
      btop.enable = true;
      carapace.enable = true;
      direnv.enable = true;
      fastfetch.enable = true;
      fish.enable = true;
      nu.enable = true;
      git.enable = true;
      helix.enable = true;
      tmux.enable = true;
      yazi.enable = true;
    };

    home.packages = with pkgs; [
      caligula # iso burner
      dust # fancy du
      self'.packages.eos-cli
      self'.packages.eos-helpers
      fd # find files
      file # identify files
      fzf # fuzzy finder
      gdu # disk utiliser
      heh # hex editor
      iamb # matrix
      jq # json processor
      just # make file but better
      libnotify # notifs through scripts
      ngrok # reverse proxy
      nixfmt # nix formatter
      ouch # cli for compressing and decompressing formats
      outfieldr # `tldr` client
      pik # Interactive pkill
      self'.packages.owo-sh
      unrar
      wget
      ffmpeg
      imagemagick
      yt-dlp
    ];

    home.shellAliases = {
      n = "cd ~/Projects/erebus";
    };
  };
}
