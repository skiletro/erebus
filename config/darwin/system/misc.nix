{
  system.defaults = {
    LaunchServices.LSQuarantine = false; # gets rid of the "are you sure" msg when opening new app
    CustomUserPreferences."com.apple.desktopservices" = {
      DSDontWriteNetworkStores = true;
      DSDontWriteUSBStores = true;
    };
  };
}
