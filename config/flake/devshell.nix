{
  perSystem =
    { pkgs, ... }:
    {
      devShells.default = pkgs.mkShellNoCC {
        buildInputs = with pkgs; [
          git
          lazygit
          just
          nh
          nvfetcher
          ssh-to-age
          sops
          nixos-rebuild
          neovim
        ];
        shellHook = ''
          just -l -u
        '';
      };
    };
}
