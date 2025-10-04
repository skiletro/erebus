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
        ];
        shellHook =
          ''
            just -l -u
          '';
      };
    };
}
