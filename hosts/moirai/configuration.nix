{ pkgs, ... }:
{
  erebus = {
    system.user.enable = true;
  };

  home-manager.sharedModules = [
    {
      erebus.programs = {
        bat.enable = true;
        direnv.enable = true;
        discord.enable = true;
        eza.enable = true;
        fastfetch.enable = true;
        fish.enable = true;
        ghostty.enable = true;
        git.enable = true;
        helix.enable = true;
        yazi.enable = true;
        spotify.enable = true;
        zen.enable = true;
        prismlauncher.enable = true;
      };
    }
  ];

  environment.systemPackages = with pkgs; [
    ffmpeg
    fzf
    lazygit
    moonlight-qt
    obsidian
    utm
    yt-dlp
  ];

  homebrew = {
    # TODO: install as many of these as i can with nix instead of homebrew
    casks = [
      "aerospace"
      "betterdisplay"
      "blender"
      "elmedia-player"
      "ente"
      "godot"
      "handbrake-app"
      "jordanbaird-ice" # hides some icons in menu bar
      "microsoft-office"
      "microsoft-teams"
      "orion"
      "pearcleaner"
      "plex"
      "proton-drive"
      "proton-mail"
      "proton-pass"
      "protonvpn"
      "qbittorrent"
      "qlvideo"
      "raycast"
      "rectangle"
      "signal"
      "tomatobar" # pomodoro timer
      "unity-hub"
      "whatsapp"
    ];

    brews = [
      "cava"
      "sketchybar" # TODO: actually configure this with nix
      "skhd-zig" # TODO: probably just replace this with aerospace once configured
    ];
  };

  system.stateVersion = 6; # do not change
}
