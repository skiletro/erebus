{
  services.karakeep = {
    enable = true;
    extraEnvironment = {
      PORT = "3001";
      DISABLE_SIGNUPS = "true";
      DISABLE_NEW_RELEASE_CHECK = "true";
    };
  };
}
