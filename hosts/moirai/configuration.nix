{ pkgs, self', ... }:
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
    self'.packages.helium-browser-bin
    iina # media player
    inkscape
    m-cli
    moonlight-qt
    obsidian
    qbittorrent
    raycast
    signal-desktop-bin
    utm
    whatsapp-for-mac
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
