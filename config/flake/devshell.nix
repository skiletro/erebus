{
  perSystem =
    { pkgs, pkgs', ... }:
    {
      devShells.default = pkgs.mkShellNoCC {
        buildInputs = with pkgs; [
          # keep-sorted start ignore_prefixes=pkgs'
          pkgs'.eos-cli
          git
          lazygit
          neovim
          nh
          nixos-rebuild
          nvfetcher
          sops
          ssh-to-age
          # keep-sorted end
        ];
        shellHook = ''
          eos
        '';
      };
    };
}
