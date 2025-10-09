{
  perSystem =
    { pkgs, ... }:
    {
      devShells.default = pkgs.mkShellNoCC {
        buildInputs = with pkgs; [
          git
          just
          nh
          nvfetcher
          ssh-to-age
          sops
          nixos-rebuild
        ];
        shellHook = ''
          just -l -u
        '';
      };
    };
}
