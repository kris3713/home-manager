{
  description = "Home Manager configuration of kris";

  inputs =
    {
      # Specify the source of Home Manager and Nixpkgs.
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

      home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      nix-fish = {
        url = "github:Animeshz/nix.fish";
        flake = false;
      };

      replay-fish = {
        url = "github:jorgebucaran/replay.fish";
        flake = false;
      };

      # Add fish plugins as inputs
      catppuccin-fish-theme = {
        url = "github:catppuccin/fish";
        flake = false;
      };

      # For Ghostty
      catppuccin-ghostty-theme = {
        url = "github:catppuccin/ghostty";
        flake = false;
      };

      # For btop
      catppuccin-btop-theme = {
        url = "github:catppuccin/btop";
        flake = false;
      };
    };

  outputs =
    {
      nixpkgs,
      home-manager,
      nix-fish,
      replay-fish,
      catppuccin-fish-theme,
      catppuccin-ghostty-theme,
      catppuccin-btop-theme,
      ...
    }:

    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      homeConfigurations."kris" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = {
          inherit
            catppuccin-fish-theme
            nix-fish replay-fish
            catppuccin-ghostty-theme
            catppuccin-btop-theme;
        };
      };
    };
}
