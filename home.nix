{
  ## flakes
  config,
  pkgs,
  # flake-utils,
  lib,
  ## user-defined variables
  appleFonts,
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

    # The home.packages option allows you to install Nix packages into your
    # environment.
    packages = with pkgs; [
      ## fonts
      appleFonts.sf-compact
      appleFonts.sf-pro
      appleFonts.ny
      source-sans
      source-sans-pro
      source-serif
      source-serif-pro
      twitter-color-emoji

      ## others
      adbtuifm
      alejandra
      argc
      # azure-cli
      babelfish
      biome
      bit
      broot
      cobra-cli
      # cargo-binstall
      cargo-cache
      cargo-update
      checkstyle
      cheat
      cht-sh
      complgen
      curlFull
      deadnix
      delve
      deno
      determinateNixManual
      dnslookup
      dragon-drop
      docker-language-server
      dogedns
      doggo
      doxx
      dprint
      duf
      dust
      editorconfig-checker
      emmylua-ls
      eza
      f2
      fcp
      ferron
      fh # FlakeHub CLI
      fx
      gh
      git-machete
      git-town
      # gpufetch
      gofumpt
      golangci-lint
      golangci-lint-langserver
      gomodifytags
      gopls
      grex
      gut
      hadolint
      impl
      # intelli-shell
      jless
      ktlint
      lazygit
      lazysql
      librespeed-cli
      linux_logo
      lnav
      lsd
      lua-language-server
      lua5_4
      lua54Packages.luarocks
      lurk
      ltex-ls-plus
      macchina
      # marksman
      markdown-oxide
      mc # Midnight Commander
      micro
      most
      navi
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
      obs-cmd
      ookla-speedtest
      ov
      pdfcpu
      peco
      pfetch-rs
      php
      php84Packages.composer
      php84Packages.phan
      # pixi
      powershell
      powershell-editor-services
      quickemu
      ramfetch
      ripdrag
      ripgrep
      # ruby_3_4
      # rubyPackages_3_4.psych
      ruff
      sad
      screenfetch
      sd
      selene
      shfmt
      shellcheck
      smap
      static-web-server
      statix
      stylua
      sshpass
      superhtml
      systemd-lsp
      tailspin
      termscp
      tinyxxd
      ttop
      tre-command
      update-nix-fetchgit
      usql
      uncrustify
      uv
      vimv
      vtracer
      watchman
      xdg-terminal-exec-mkhl
      xxh
      # yazi-unwrapped
      yq-go
      yt-dlp
      zigfetch

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
