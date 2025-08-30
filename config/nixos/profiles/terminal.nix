{
  lib,
  config,
  pkgs,
  ...
}: {
  options.erebus.profiles.terminal.enable = lib.mkEnableOption "terminal applications that are generally wanted on all systems, but aren't required like the `base` profile.";

  config = lib.mkIf config.erebus.profiles.terminal.enable {
    home-manager.sharedModules = lib.singleton {
      erebus.programs = {
        bat.enable = true;
        beets.enable = true;
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
        du-dust # fancy du
        fd # find files
        file # identify files
        fzf # fuzzy finder
        jq # json processor
        just # make file but better
        libnotify # notifs through scripts
        ngrok # reverse proxy
        nixfmt # nix formatter
        ouch # cli for compressing and decompressing formats
        outfieldr # `tldr` client
        playerctl # control media w/ cli
        unrar
        wget
        wineWowPackages.stable # wine
      ];
    };
  };
}
