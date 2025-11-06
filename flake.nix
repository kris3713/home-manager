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

      # Add fish plugins as inputs
      fisher = {
        url = "github:jorgebucaran/fisher";
        flake = false;
      };

      replay-fish = {
        url = "github:jorgebucaran/replay.fish";
        flake = false;
      };

      nix-completions-fish = {
        url = "github:kidonng/nix-completions.fish";
        flake = false;
      };

      nix-fish = {
        url = "github:Animeshz/nix.fish";
        flake = false;
      };


      catppuccin-fish-theme = {
        url = "github:catppuccin/fish";
        flake = false;
      };

      # Ghostty
      catppuccin-ghostty-theme = {
        url = "github:catppuccin/ghostty";
        flake = false;
      };

      # btop
      catppuccin-btop-theme = {
        url = "github:catppuccin/btop";
        flake = false;
      };

      # bat
      catppuccin-bat-theme = {
        url = "github:catppuccin/bat";
        flake = false;
      };

      # atuin
      catppuccin-atuin-theme = {
        url = "github:catppuccin/atuin";
        flake = false;
      };

      # lsd
      catppuccin-lsd-theme = {
        url = "github:catppuccin/lsd";
        flake = false;
      };
    };

  outputs =
    {
      nixpkgs,
      home-manager,
      fisher,
      replay-fish,
      nix-completions-fish,
      nix-fish,
      catppuccin-fish-theme,
      catppuccin-ghostty-theme,
      catppuccin-btop-theme,
      catppuccin-bat-theme,
      catppuccin-atuin-theme,
      catppuccin-lsd-theme,
      ...
    }:

    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      homeManagerLib = home-manager.lib;
    in
    {
      homeConfigurations."kris" = homeManagerLib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = {
          inherit
            fisher
            replay-fish
            nix-completions-fish
            nix-fish
            catppuccin-fish-theme
            catppuccin-ghostty-theme
            catppuccin-btop-theme
            catppuccin-bat-theme
            catppuccin-atuin-theme
            catppuccin-lsd-theme;
        };
      };
    };
}
