{
  ## flakes
  config,
  pkgs,
  # flake-utils,
  # lib,
  ## user-defined variables
  determinateNixManual,
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
}:

let
  # important variables
  # hm = lib.hm;
  configHome = config.home;
  username = configHome.username;
  homeDirectory = configHome.homeDirectory;

  # other variables
  fishPlugins = pkgs.fishPlugins;
  userBinDir = "${homeDirectory}/.local/bin";
  userDataDir = "${homeDirectory}/.local/share";
  userStateDir = "${homeDirectory}/.local/state";
  userConfigDir = "${homeDirectory}/.config";
  fishDir = "${userConfigDir}/fish";
in
{
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
    stateVersion = "25.05"; # Please read the comment before changing.

    # The home.packages option allows you to install Nix packages into your
    # environment.
    packages = with pkgs; [
      ## fonts
      source-sans
      source-sans-pro
      source-serif
      source-serif-pro
      twitter-color-emoji

      ## others
      actionlint
      adbtuifm
      alejandra
      # atuin
      argc
      # azure-cli
      babelfish
      biome
      bit
      broot
      cobra-cli
      cargo-cache
      cargo-update
      checkstyle
      cheat
      cht-sh
      complgen
      deadnix
      deno
      determinateNixManual
      dnslookup
      dragon-drop
      dogedns
      doggo
      doxx
      dprint
      duf
      dust
      eza
      f2
      fd
      ferron
      ffmpeg-full
      fh # FlakeHub CLI
      fzf
      gh
      git-machete
      git-town
      gpufetch
      gofumpt
      golangci-lint
      golangci-lint-langserver
      grex
      gut
      intelli-shell
      ktlint
      lazydocker
      lazygit
      lazysql
      librespeed-cli
      linux_logo
      lnav
      lsd
      lsp-ai
      lua-language-server
      lua5_4
      lua54Packages.luarocks
      lurk
      macchina
      markdown-oxide
      mc # Midnight Commander
      micro
      most
      neofetch
      neovim-unwrapped
      netscanner
      nh
      nil
      nix-info
      nix-init
      nix-your-shell
      niv
      nmap
      nvtopPackages.intel
      obs-cmd
      omnix
      ookla-speedtest
      ov
      oxker
      pdfcpu
      peco
      pfetch-rs
      php
      php84Packages.composer
      php84Packages.phan
      quickemu
      ramfetch
      ripdrag
      ripgrep
      sad
      screenfetch
      sd
      shfmt
      shellcheck
      smap
      static-web-server
      statix
      stylua
      sshpass
      tailspin
      termscp
      tinyxxd
      ttop
      tre-command
      update-nix-fetchgit
      usql
      uncrustify
      vimv
      vtracer
      watchman
      wikiman
      xdg-terminal-exec-mkhl
      xxh
      yamlfmt
      yq-go
      yt-dlp

      # # Adds the 'hello' command to your environment. It prints a friendly
      # # "Hello, world!" when run.
      # pkgs.hello

      # # It is sometimes useful to fine-tune packages, for example, by applying
      # # overrides. You can do that directly here, just don't forget the
      # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
      # # fonts?
      # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

      # # You can also create simple shell scripts directly inside your
      # # configuration. For example, this adds a command 'my-hello' to your
      # # environment:
      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')
    ];

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

  programs = {
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
        { # autopair.fish
          name = "autopair";
          src = autopair.src;
        }
        { # bass
          name = "bass";
          src = bass.src;
        }
        { # sdkman-for-fish
          name = "sdkman";
          src = sdkman-for-fish.src;
        }
        { # fzf.fish
          name = "fzf";
          src = fzf-fish.src;
        }
        # { # fifc
        #   name = "fifc";
        #   src = fifc.src;
        # }
        ## fish plugins not packaged in nixpkgs
        { # completions.fish
          name = "completions";
          src = completions_fish;
        }
        { # fisher
          name = "fisher";
          src = fisher;
        }
        { # replay.fish
          name = "replay";
          src = replay_fish;
        }
        { # nix-completions.fish
          name = "nix-completions";
          src = nix-completions_fish;
        }
        { # nix.fish
          name = "nix";
          src = nix_fish;
        }
      ];
    };
  };
}
