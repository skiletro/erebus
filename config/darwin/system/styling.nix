{lib, ...}: {
  home-manager.sharedModules = lib.singleton ({
    lib,
    config,
    ...
  }: {
    home.activation."setWallpaper" = lib.hm.dag.entryAfter ["writeBoundary"] ''
      echo "Setting wallpaper..."
      /usr/bin/osascript -e "tell application \"Finder\" to set desktop picture to POSIX file \"${config.stylix.image}\""
    '';

    # Increase the system font size for macOS to compensate for the
    # HiDPI displays.
    stylix.fonts.sizes = with lib; {
      terminal = mkForce 14;
      applications = mkForce 14;
    };
  });
}
