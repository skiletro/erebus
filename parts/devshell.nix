{
  perSystem =
    { pkgs, ... }:
    {
      devShells.default = pkgs.mkShellNoCC {
        buildInputs = with pkgs; [
          git
          just
          nh
        ];
        shellHook =
          let
            # TODO: there is probably a *much* nicer way of doing this.
            darwinFix = if pkgs.stdenvNoCC.hostPlatform.isDarwin then "ulimit -n 10240" else "";
          in
          ''
            just -l -u
            ${darwinFix}
          '';
      };
    };
}
