{
  description = "Home Manager configuration of kris";

  inputs =
    {
      nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*";

      determinate-nix-src.url = "https://flakehub.com/f/DeterminateSystems/nix-src/0.1.*";

      flake-utils.url = "https://flakehub.com/f/numtide/flake-utils/0.*";

      home-manager = {
        url = "https://flakehub.com/f/nix-community/home-manager/0.1.*";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      ## FISH plugins
      autopair_fish = {
        url = "github:jorgebucaran/autopair.fish";
        flake = false;
      };

      completions_fish = {
        url = "github:kidonng/completions.fish";
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
        url = "github:kris3713/nix-completions.fish";
        flake = false;
      };

      nix_fish = {
        url = "github:Animeshz/nix.fish";
        flake = false;
      };

      sdkman-for-fish = {
        url = "github:reitzig/sdkman-for-fish";
        flake = false;
      };
      ## end of FISH plugins

      ## Catppuccin themes
      # fish
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
      ## end of Catppuccin themes
    };

  outputs =
    {
      ## flakes
      nixpkgs,
      determinate-nix-src,
      home-manager,
      flake-utils,
      ## non-flakes
      autopair_fish,
      completions_fish,
      fishPlugin-bass,
      fisher,
      replay_fish,
      nix-completions_fish,
      nix_fish,
      sdkman-for-fish,
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
      username = "kris";
      pkgs = nixpkgs.legacyPackages.${system};
      determinateNixManual = determinate-nix-src.packages.${system}.nix-manual;
      homeManagerLib = home-manager.lib;
    in
    {
      homeConfigurations.${username} = homeManagerLib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = {
          inherit
            ## flakes
            flake-utils
            ## variables
            determinateNixManual
            ## non-flakes
            autopair_fish
            completions_fish
            fishPlugin-bass
            fisher
            replay_fish
            nix-completions_fish
            nix_fish
            sdkman-for-fish
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
