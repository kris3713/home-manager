{
  ## user-defined variables
  pkgs,
  nurRepos,
  appleFonts,
  determinateNix,
  ...
}: let
  inherit
    (nurRepos)
    charmbracelet
    ;
in {
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages =
    ## fonts
    (with appleFonts; [
      sf-compact.out
      sf-pro.out
      ny.out
    ])
    ++
    ## determinate-nix src packages
    (with determinateNix; [
      # determinate-nix man pages
      nix.man
    ])
    ++
    ## charmbracelet packages
    (with charmbracelet; [
      crush
    ])
    ++
    ## other packages
    (with pkgs; [
      source-sans.out
      source-sans-pro.out
      source-serif.out
      source-serif-pro.out
      twitter-color-emoji.out

      ## others
      adbtuifm
      alejandra
      argc
      babelfish
      biome
      bit
      broot
      bottom
      cachix
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
      ferron
      fh # FlakeHub CLI
      fx
      gh
      git-machete
      git-town
      gofumpt
      golangci-lint
      golangci-lint-langserver
      gomodifytags
      gopls
      grex
      gut
      hadolint
      impl
      jless
      ktlint
      lazygit
      lazysql
      # (llama-cpp.override { cudaSupport = true; })
      librespeed-cli
      linux_logo
      lnav
      lsd
      lua-language-server
      lurk
      ltex-ls-plus
      macchina
      marksman
      mc # Midnight Commander
      micro
      most
      moor
      navi
      # neovim-unwrapped
      # neovim-qt-unwrapped
      netscanner
      nh
      nickel
      nls
      nil
      nix-info
      nix-init
      nix-your-shell
      niv
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
      pyrefly
      quickemu
      ramfetch
      resvg
      ripdrag
      ripgrep
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
      systemd-lsp
      tailspin
      tealdeer
      termscp
      tinyxxd
      ttop
      tre-command
      ty
      update-nix-fetchgit
      usql
      uncrustify
      vimv
      vtracer
      # watchman
      xxh
      yazi-unwrapped
      yq-go
      yt-dlp
      zigfetch
    ]);

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
  };
}
