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
      bat.enable = true;
      beets.enable = lib.mkIf pkgs.stdenvNoCC.hostPlatform.isLinux true;
      btop.enable = true;
      carapace.enable = true;
      direnv.enable = true;
      eza.enable = true;
      fastfetch.enable = true;
      fish.enable = true;
      git.enable = true;
      helix.enable = true;
      tmux.enable = true;
      yazi.enable = true;
    };

    home.packages = with pkgs; [
      caligula # iso burner
      du-dust # fancy du
      fd # find files
      file # identify files
      fzf # fuzzy finder
      heh # hex editor
      iamb # matrix
      jq # json processor
      just # make file but better
      libnotify # notifs through scripts
      ngrok # reverse proxy
      nixfmt # nix formatter
      ncdu
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
  };
}
