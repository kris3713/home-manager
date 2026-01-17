{
  ## flakes
  config,
  pkgs,
  # flake-utils,
  lib,
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
  # important variables
  # hm = lib.hm;
  inherit (lib) mkForce;
  configHome = config.home;
  inherit (configHome) username;
  inherit (configHome) homeDirectory;

  # other variables
  inherit (pkgs) fishPlugins;
  userBinDir = "${homeDirectory}/.local/bin";
  userDataDir = "${homeDirectory}/.local/share";
  userStateDir = "${homeDirectory}/.local/state";
  userConfigDir = "${homeDirectory}/.config";
  fishDir = "${userConfigDir}/fish";
in {
  nixpkgs.config.allowUnfree = true;

  home = {
    # Home Manager needs a bit of information about you and the paths it should
    # manage.
    username = "kris";
    homeDirectory = "/home/${username}";

    # activation = {};

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "25.11"; # Please read the comment before changing.

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    file = {
      # # Building this configuration will create a copy of 'dotfiles/screenrc' in
      # # the Nix store. Activating the configuration will then make '~/.screenrc' a
      # # symlink to the Nix store copy.
      # ".screenrc".source = dotfiles/screenrc;

      # # You can also set the file content immediately.
      # ".gradle/gradle.properties".text = ''
      #   org.gradle.console=verbose
      #   org.gradle.daemon.idletimeout=3600000
      # '';

      # lazygit alias
      "${userBinDir}/lg" = {
        source = "${pkgs.lazygit}/bin/lazygit";
      };

      # doge alias
      "${userBinDir}/dog" = {
        source = "${pkgs.dogedns}/bin/doge";
      };

      ## others
      "${userConfigDir}/ghostty/themes" = {
        recursive = true;
        source = "${catppuccin-ghostty-theme}/themes";
      };

      "${userConfigDir}/btop/themes" = {
        recursive = true;
        source = "${catppuccin-btop-theme}/themes";
      };

      "${userConfigDir}/bat/themes" = {
        recursive = true;
        source = "${catppuccin-bat-theme}/themes";
      };

      "${userConfigDir}/lsd/colors.yaml" = {
        source = "${catppuccin-lsd-theme}/themes/catppuccin-macchiato/colors.yaml";
      };

      "${homeDirectory}/catppuccin-delta-theme.gitconfig" = {
        source = "${catppuccin-delta-theme}/catppuccin.gitconfig";
      };

      "${userConfigDir}/micro/colorschemes" = {
        recursive = true;
        source = "${catppuccin-micro-theme}/themes";
      };
    };

    # Home Manager can also manage your environment variables through
    # 'home.sessionVariables'. These will be explicitly sourced when using a
    # shell provided by Home Manager. If you don't want to manage your shell
    # through Home Manager then you have to manually source 'hm-session-vars.sh'
    # located at either
    #
    #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  /etc/profiles/per-user/kris/etc/profile.d/hm-session-vars.sh
    #
    sessionVariables = {
      NIXPKGS_ALLOW_UNFREE = 1;
      NH_NO_CHECKS = 1;
      # XDG_CONFIG_HOME
      XDG_CONFIG_HOME = userConfigDir;
      # XDG_DATA_HOME
      XDG_DATA_HOME = userDataDir;
      # XDG_STATE_HOME
      XDG_STATE_HOME = userStateDir;
    };
  };

  # Silence news completely.
  news = {
    display = "silent";
    json = mkForce {};
    entries = mkForce [];
  };

  programs = {
    # DOOM Emacs
    doom-emacs = {
      enable = true;
      doomDir = ./doom;
    };

    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    # Manage direnv using Nix and Home Manager.
    direnv = {
      enable = true;
      enableBashIntegration = true;

      # nix-direnv
      nix-direnv.enable = true;
    };

    # Manage the fish shell using Nix and Home Manager.
    fish = {
      enable = true;
      shellInit = ''
        # source other fish config
        source '${fishDir}/config.backup.fish'

        ## Shell completions creation
        # gut
        gut completion fish | source
        ## end of Shell completions creation
      '';

      plugins = with fishPlugins; [
        ## fish plugins packaged in nixpkgs
        {
          # autopair.fish
          name = "autopair";
          src = autopair.src;
        }
        {
          # bass
          name = "bass";
          src = bass.src;
        }
        {
          # sdkman-for-fish
          name = "sdkman";
          src = sdkman-for-fish.src;
        }
        {
          # fzf.fish
          name = "fzf";
          src = fzf-fish.src;
        }
        # { # fifc
        #   name = "fifc";
        #   src = fifc.src;
        # }
        ## fish plugins not packaged in nixpkgs
        {
          # completions.fish
          name = "completions";
          src = completions_fish;
        }
        {
          # fisher
          name = "fisher";
          src = fisher;
        }
        {
          # replay.fish
          name = "replay";
          src = replay_fish;
        }
        {
          # nix-completions.fish
          name = "nix_completions";
          src = nix-completions_fish;
        }
        {
          # nix.fish
          name = "nix";
          src = nix_fish;
        }
      ];
    };
  };
}
