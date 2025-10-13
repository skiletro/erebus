{
  services.karakeep = {
    enable = true;
    meilisearch.enable = false; # what is the POINT of stateVersion if it doesn't WORK
    extraEnvironment = {
      NEXTAUTH_URL = "https://kk.warm.vodka";
      PORT = "3001";
      DISABLE_SIGNUPS = "true";
      DISABLE_NEW_RELEASE_CHECK = "true";
    };
  };
}
