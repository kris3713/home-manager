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
      autopair_fish = {
        url = "github:jorgebucaran/autopair.fish";
        flake = false;
      };

      fishPlugin-bass = {
        url = "github:edc/bass";
        flake = false;
      };

      fisher = {
        url = "github:jorgebucaran/fisher";
        flake = false;
      };

      replay_fish = {
        url = "github:jorgebucaran/replay.fish";
        flake = false;
      };

      nix-completions_fish = {
        url = "github:dmitrii-galantsev/nix-completions.fish";
        flake = false;
      };

      nix_fish = {
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

      # delta
      catppuccin-delta-theme = {
        url = "github:catppuccin/delta";
        flake = false;
      };
    };

  outputs =
    {
      nixpkgs,
      home-manager,
      autopair_fish,
      fishPlugin-bass,
      fisher,
      replay_fish,
      nix-completions_fish,
      nix_fish,
      catppuccin-fish-theme,
      catppuccin-ghostty-theme,
      catppuccin-btop-theme,
      catppuccin-bat-theme,
      catppuccin-atuin-theme,
      catppuccin-lsd-theme,
      catppuccin-delta-theme,
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
            autopair_fish
            fishPlugin-bass
            fisher
            replay_fish
            nix-completions_fish
            nix_fish
            catppuccin-fish-theme
            catppuccin-ghostty-theme
            catppuccin-btop-theme
            catppuccin-bat-theme
            catppuccin-atuin-theme
            catppuccin-lsd-theme
            catppuccin-delta-theme;
        };
      };
    };
}
