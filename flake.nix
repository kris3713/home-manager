{
  description = "Home Manager configuration of kris";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*";

    determinate-nix-src.url = "https://flakehub.com/f/DeterminateSystems/nix-src/*";

    flake-utils.url = "https://flakehub.com/f/numtide/flake-utils/0.*";

    home-manager = {
      url = "https://flakehub.com/f/nix-community/home-manager/0.1.*";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-doom-emacs-unstraightened = {
      url = "github:marienz/nix-doom-emacs-unstraightened";
      inputs.nixpkgs.follows = "";
    };

    # Apple Fonts
    apple-fonts = {
      url = "github:Lyndeno/apple-fonts.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ## FISH plugins
    completions_fish = {
      url = "github:kidonng/completions.fish";
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
    ## end of FISH plugins

    ## Catppuccin themes
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

    # micro
    catppuccin-micro-theme = {
      url = "github:catppuccin/micro";
      flake = false;
    };
    ## end of Catppuccin themes
  };

  outputs = {
    ## flakes
    nixpkgs,
    determinate-nix-src,
    flake-utils,
    home-manager,
    nix-doom-emacs-unstraightened,
    apple-fonts,
    ## non-flakes
    completions_fish,
    fisher,
    replay_fish,
    nix-completions_fish,
    nix_fish,
    catppuccin-ghostty-theme,
    catppuccin-btop-theme,
    catppuccin-bat-theme,
    catppuccin-lsd-theme,
    catppuccin-delta-theme,
    catppuccin-micro-theme,
    ...
  }: let
    system = "x86_64-linux";
    username = "kris";
    pkgs = nixpkgs.legacyPackages.${system};
    determinateNixManual = determinate-nix-src.packages.${system}.nix.man;
    appleFonts = apple-fonts.packages.${system};
    homeManagerLib = home-manager.lib;
    inherit (homeManagerLib) homeManagerConfiguration;
  in {
    homeConfigurations.${username} = homeManagerConfiguration {
      inherit pkgs;

      # Specify your home configuration modules here, for example,
      # the path to your `home.nix`
      modules = [
        nix-doom-emacs-unstraightened.homeModule
        ./extras/files.nix
        ./extras/fish.nix
        ./extras/pkgs.nix
        ./home.nix
      ];

      # Optionally use extraSpecialArgs
      # to pass through arguments to your configuration modules
      extraSpecialArgs = {
        inherit
          ## flakes
          flake-utils
          ## variables
          appleFonts
          determinateNixManual
          ## non-flakes
          completions_fish
          fisher
          replay_fish
          nix-completions_fish
          nix_fish
          catppuccin-ghostty-theme
          catppuccin-btop-theme
          catppuccin-bat-theme
          catppuccin-lsd-theme
          catppuccin-delta-theme
          catppuccin-micro-theme
          ;
      };
    };
  };
}
