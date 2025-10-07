{
  config,
  pkgs,
  # lib,
  catppuccin-fish-theme,
  nix-fish,
  replay-fish,
  ...
}:

let
  # important variables
  # NOTE: Always set new hashes to "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
  # in order to get the actual hash
  # fetchFromGitHub = pkgs.fetchFromGitHub;

  # hm = lib.hm;
  configHome = config.home;

  # other variables
  # fishPlugins = pkgs.fishPlugins;
in
{
  nixpkgs.config.allowUnfree = true;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "kris";
  home.homeDirectory = "/home/kris";

  home.activation = {
    # # For some reason, home-manager keeps messing with mimeapps.list
    # # To counter this, we'll just back up the file and restore it afterwards
    # backupAndRestoreMimeAppsList = hm.dag.entryBefore [ "checkLinkTargets" ] ''
    #   MIME_APPS_LIST='${configHome.homeDirectory}/.config/mimeapps.list'
    #
    #   if [ ! -f "$MIME_APPS_LIST.bak" ]; then
    #     cp -f "$MIME_APPS_LIST" "$MIME_APPS_LIST.bak"
    #   fi
    #
    #   mv -f "$MIME_APPS_LIST.bak" "$MIME_APPS_LIST"
    #   cp -f "$MIME_APPS_LIST" "$MIME_APPS_LIST.bak"
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
    twitter-color-emoji

    ## others
    adbtuifm
    alejandra
    atuin
    # azure-cli
    broot
    cobra-cli
    cargo-cache
    cargo-update
    checkstyle
    cod
    complgen
    direnv
    deno
    deadnix
    dnslookup
    dragon-drop
    dogedns
    eza
    element-desktop
    fh # FlakeHub CLI
    git-machete
    gpufetch
    gofumpt
    golangci-lint
    hyfetch
    lftp
    librespeed-cli
    linux_logo
    lsp-ai
    lurk
    ktlint
    mc # Midnight Commander
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
    php
    php84Packages.composer
    php84Packages.phan
    quickemu
    ramfetch
    ripdrag
    ruby
    smap
    termscp
    tinyxxd
    ttop
    update-nix-fetchgit
    usql
    vimv
    vtracer
    watchman
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
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    "${configHome.homeDirectory}/.config/fish/themes" = {
      recursive = true;
      source = "${catppuccin-fish-theme}/themes";
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
  home.sessionVariables = {
    # EDITOR = "emacs";
    NH_NO_CHECKS = 1;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.fish = {
    enable = true;
    shellInit = ''
      # source other fish config
      source '${configHome.homeDirectory}/.config/fish/config.backup.fish'

      ## Shell completions creation
      # gut
      gut completion fish > '${configHome.homeDirectory}/.config/fish/completions/gut.fish'
      ## end of Shell completions creation
    '';

    plugins = [
      {
        name = "nix";
        src = nix-fish;
      }
      {
        name = "replay";
        src = replay-fish;
      }
    ];
  };

  # Don't allow home-manager to modify mimeapps.list
  xdg.mime.enable = false;
}
