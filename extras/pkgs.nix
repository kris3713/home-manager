{
  ## user-defined variables
  pkgs,
  appleFonts,
  determinateNix,
  ...
}: {
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages =
    ## fonts
    (with appleFonts; [
      sf-compact
      sf-pro
      ny
    ])
    ++
    ## determinate-nix src packages
    (with determinateNix; [
      # determinate-nix man pages
      nix.man
    ])
    ++
    ## other packages
    (with pkgs; [
      source-sans
      source-sans-pro
      source-serif
      source-serif-pro
      twitter-color-emoji

      ## others
      adbtuifm
      alejandra
      argc
      babelfish
      biome
      bit
      broot
      cobra-cli
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
      fcp
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
      lurk
      ltex-ls-plus
      macchina
      marksman
      mc # Midnight Commander
      micro
      most
      moor
      navi
      neofetch
      # neovim-unwrapped
      # neovim-qt-unwrapped
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
      pyrefly
      quickemu
      ramfetch
      resvg
      ripdrag
      ripgrep
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
      tealdeer
      termscp
      tinyxxd
      ttop
      tre-command
      ty
      update-nix-fetchgit
      usql
      uncrustify
      uv
      vimv
      vtracer
      watchman
      xdg-terminal-exec-mkhl
      xxh
      yazi-unwrapped
      yq-go
      yt-dlp
      zigfetch
      zuban
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
