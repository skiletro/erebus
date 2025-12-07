{
  perSystem =
    { pkgs, self', ... }:
    {
      devShells.default = pkgs.mkShellNoCC {
        buildInputs = with pkgs; [
          git
          lazygit
          nh
          nvfetcher
          ssh-to-age
          sops
          nixos-rebuild
          neovim
          self'.packages.eos-cli
        ];
        shellHook = ''
          eos
          echo "Usage: eos [cmd]"
        '';
      };
    };
}
