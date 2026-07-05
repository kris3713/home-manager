{
  ## defaults
  config,
  ## extras
  inputs,
  ## user-defined variables
  pkgs,
  # determinateNix,
  ...
}: let
  configHome = config.home;
  inherit (configHome) homeDirectory;

  userBinDir = "${homeDirectory}/.local/bin";
  userConfigDir = "${homeDirectory}/.config";
in {
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = with inputs; {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';

    ## Scripts
    # llama-gguf-downloader
    "${userBinDir}/llama-gguf-downloader" = {
      text = /* sh */ ''
        #!/usr/bin/env sh

        env LLAMA_CACHE="$HOME/llama-swap/models" \
          llama-cli -p '/exit' -n 1 --no-display-prompt -hf  "$@"
      '';
      executable = true;
    };

    # restart-plasmashell
    "${userBinDir}/restart-plasmashell" = {
      text = /* sh */ ''
        #!/usr/bin/env sh

        systemctl --user restart plasma-plasmashell.service
      '';
      executable = true;
    };

    # create-distrobox
    "${userBinDir}/create-distrobox" = {
      text = /* sh */ ''
        #!/usr/bin/env sh
        # shellcheck disable=1009,1073,1003

        distrobox-create -Y -i ghcr.io/ultramarine-linux/ultramarine:43 -n fedora_distrobox \
          -ap 'rpmdevtools @development-tools xclip wl-clipboard dnf-plugins-core' \
          --init-hooks "$(cat << 'sh'

        if [ ! -f /bin/cls ]; then
          sudo ln -sf "$(command -v clear)" /bin/cls;
        fi;

        if ! cat /etc/dnf/dnf.conf | grep -qF 'install_weak_deps=False'; then
          echo -e 'install_weak_deps=False\nbest=True' | sudo tee -a /etc/dnf/dnf.conf &> /dev/null;
        fi;

        sh
        )"
      '';
      executable = true;
    };

    ## Aliases
    # lazygit alias
    "${userBinDir}/lg".source = "${pkgs.lazygit}/bin/lazygit";

    # doge alias
    "${userBinDir}/dog".source = "${pkgs.dogedns}/bin/doge";

    ## Others
    "${userConfigDir}/containers/containers.conf".text = /* toml */ ''
      runtime = 'crun'
    '';

    "${userConfigDir}/containers/storage.conf".text = /* toml */ ''
      graphroot="''${HOME}/.local/share/containers/storage"
      runroot="''${XDG_RUNTIME_DIR}/containers"
    '';

    "${userConfigDir}/btop/themes" = {
      recursive = true;
      source = "${catppuccin-btop-theme}/themes";
    };

    "${userConfigDir}/bat/themes" = {
      recursive = true;
      source = "${catppuccin-bat-theme}/themes";
    };

    "${userConfigDir}/bat/config".text = ''
      --plain
      "--theme=Catppuccin Macchiato"
      "--style=numbers"
    '';

    "${userConfigDir}/ghostty/themes" = {
      recursive = true;
      source = "${catppuccin-ghostty-theme}/themes";
    };

    "${userConfigDir}/ghostty/config".source = ./.config/ghostty/config;

    "${userConfigDir}/lsd/config.yml".text = /*yaml*/ ''
      color:
        theme: custom
    '';
    "${userConfigDir}/lsd/colors.yaml".source = "${catppuccin-lsd-theme}/themes/catppuccin-macchiato/colors.yaml";

    "${homeDirectory}/catppuccin-delta-theme.gitconfig".source = "${catppuccin-delta-theme}/catppuccin.gitconfig";

    "${userConfigDir}/micro/colorschemes" = {
      recursive = true;
      source = "${catppuccin-micro-theme}/themes";
    };

    "${userConfigDir}/topgrade.toml".source = ./.config/topgrade.toml;
  };
}
