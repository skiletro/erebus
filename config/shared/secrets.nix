{
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    age.sshKeyPaths = [
      "/Users/jamie/.ssh/id_ed25519"
      "/home/jamie/.ssh/id_ed25519"
    ];
    secrets = {
      "user-password" = { };
    };
  };
}
