{pkgs, ...}: {
  erebus.profiles = {
    base.enable = true;
    gaming.enable = true;
    graphical.enable = true;
    services.enable = true;
    terminal.enable = true;
  };

  environment.systemPackages = with pkgs; [
    delfin # Jellyfin Client
    flare-signal # Signal Client
    fractal # Matrix Client
    fsearch # Fast File Search
    ghex # Hex Editor
    gimp3-with-plugins
    godot_4 # Godot Engine
    handbrake # Video Encoder
    impression # ISO Burner
    inkscape-with-extensions
    itch # Itch.io Client
    kdiskmark # Drive Benchmark Tool
    libreoffice # Office Suite
    ludusavi # Game Save Backup Manager
    obs-studio # Screen Recording and Broadcast Suite
    proton-pass # Password manager
    qbittorrent # Torrent Client
    tenacity # Audio Editor
    video-trimmer # Trims Videos
    vlc # Media Player, mostly used for m3u files

    # Terminal
    ffmpeg # Manipulate Video
    imagemagick # Manipulate Images
  ];
}
