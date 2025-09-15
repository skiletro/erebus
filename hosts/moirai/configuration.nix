{ pkgs, ... }:
{
  erebus = {
    profiles = {
      base.enable = true;
      graphical.enable = true;
      terminal.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    moonlight-qt
    obsidian
    utm
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
