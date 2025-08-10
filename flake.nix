{
  outputs = inputs: inputs.flake-parts.lib.mkFlake {inherit inputs;} (inputs.import-tree ./parts);

  inputs = {
    ### Core
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    import-tree.url = "github:vic/import-tree";

    flake-schemas.url = "github:DeterminateSystems/flake-schemas";

    ### Modules
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ### Package Repositories
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    # nixos-hardware.url = "github:NixOS/nixos-hardware";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    ### Parts Modules
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ### Individual Packages
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";

    # helix = {
    #   url = "github:helix-editor/helix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    nixcord = {
      url = "github:kaylorben/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.flake-compat.follows = "";
    };

    # spicetify = {
    #   url = "github:Gerg-L/spicetify-nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    diffy = {
      url = "github:different-name/nix-files";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ### Theming
    # Inputs that provide themes or anything to do with the style of the system(s).
    cursors.url = "github:lilleaila/nix-cursors";

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
