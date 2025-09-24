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
    betterdisplay
    grandperspective
    hidden-bar
    iina # media player
    inkscape
    m-cli
    moonlight-qt
    obsidian
    qbittorrent
    raycast
    rectangle
    shortcat
    signal-desktop-bin
    skhd # simple hotkey daemon
    utm
    whatsapp-for-mac
    xbar
  ];

  homebrew = {
    # tui
    casks = [
      "blender"
      "ente"
      "godot"
      "handbrake-app" # broken
      "microsoft-office"
      "microsoft-teams"
      "orion"
      "pearcleaner"
      "pinta"
      "plex"
      "proton-drive"
      "proton-mail"
      "proton-pass"
      "protonvpn"
      "tomatobar" # pomodoro timer
      "unity-hub"
    ];

    # cli
    brews = [ ];

    # app store
    masApps = {
      Xcode = 497799835;
    };
  };

  system.stateVersion = 6; # do not change
}
