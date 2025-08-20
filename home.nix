{
  config,
  pkgs,
  lib,
  ...
}:

{
  nixpkgs.config.allowUnfree = true;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "kris";
  home.homeDirectory = "/home/kris";

  home.activation = {
    updateFontCache = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run /usr/bin/fc-cache -fv &> /dev/null
    '';

    # rebuildKdeCache = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    #   source "${builtins.getEnv "HOME"}/.bash_profile"
    #   run /usr/bin/kbuildsycoca6 --noincremental
    # '';
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    ## fonts
    source-sans
    source-sans-pro
    source-serif
    source-serif-pro

    ## others
    # adbtuifm
    adbtuifm
    # azure-cli
    azure-cli
    # broot
    broot
    # cargo-cache
    cargo-cache
    # cargo-update
    cargo-update
    # clipboard-jh
    clipboard-jh
    # cod
    cod
    # complgen
    complgen
    # direnv
    direnv
    # dnslookup
    dnslookup
    # dragon-drop
    dragon-drop
    # eza
    eza
    # fh
    fh
    # gpufetch
    gpufetch
    # hyfetch
    hyfetch
    # lftp
    lftp
    # librespeed-cli
    librespeed-cli
    # linux_logo
    linux_logo
    # lsp-ai
    lsp-ai
    # lurk
    lurk
    # mc
    mc
    # neovim-unwrapped
    neovim-unwrapped
    # netscanner
    netscanner
    # nh
    nh
    # nil
    nil
    # nix-info
    nix-info
    # nix-init
    nix-init
    # niv
    niv
    # nmap
    nmap
    # obs-cmd
    obs-cmd
    # omnix
    omnix
    # ookla-speedtest
    ookla-speedtest
    # php
    php
    # quickemu
    quickemu
    # ramfetch
    ramfetch
    # ripdrag
    ripdrag
    # ruby
    ruby
    # smap
    smap
    # termscp
    termscp
    # texliveMedium
    texliveMedium
    # tinyxxd
    tinyxxd
    # ttop
    ttop
    # twitter-color-emoji
    twitter-color-emoji
    # usql
    usql
    # vimv
    vimv
    # vtracer
    vtracer
    # watchman
    watchman
    # yt-dlp
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

  # # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # # plain files is through 'home.file'.
  # home.file = {
  #   # # Building this configuration will create a copy of 'dotfiles/screenrc' in
  #   # # the Nix store. Activating the configuration will then make '~/.screenrc' a
  #   # # symlink to the Nix store copy.
  #   # ".screenrc".source = dotfiles/screenrc;
  #
  #   # # You can also set the file content immediately.
  #   # ".gradle/gradle.properties".text = ''
  #   #   org.gradle.console=verbose
  #   #   org.gradle.daemon.idletimeout=3600000
  #   # '';
  # };

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
  home.sessionVariables = {
    # EDITOR = "emacs";
    NH_NO_CHECKS = "1";
  };

  home.file = {
    ".config/fish/themes" = {
      recursive = true;
      source = (pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "fish";
        rev = "main";
        sha256 = "sha256-Oc0emnIUI4LV7QJLs4B2/FQtCFewRFVp7EDv8GawFsA=";
      }) + "/themes";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.fish = {
    enable = true;
    shellInit = ''
      source "${config.home.homeDirectory}/.config/fish/config.backup.fish"
    '';

    # Always set new plugin hashes to 0000000000000000000000000000000000000000000000000000
    # in order to get the corrent hash from home-manager
    plugins = [
      {
        name = "replay";
        src = pkgs.fetchFromGitHub {
          owner = "jorgebucaran";
          repo = "replay.fish";
          rev = "main";
          sha256 = "sha256-TzQ97h9tBRUg+A7DSKeTBWLQuThicbu19DHMwkmUXdg=";
        };
      }
      {
        name = "sdkman-for-fish";
        src = pkgs.fishPlugins.sdkman-for-fish;
      }
    ];
  };
}
