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
          nixos-rebuild
        ];
        shellHook = ''
          just -l -u
        '';
      };
    };
}
