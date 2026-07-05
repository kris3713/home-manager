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

    "${userConfigDir}/ghostty/config".text = /* confini */ ''
      # This is the configuration file for Ghostty.
      #
      # This template file has been automatically created at the following
      # path since Ghostty couldn't find any existing config files on your system:
      #
      #   {[path]s}
      #
      # The template does not set any default options, since Ghostty ships
      # with sensible defaults for all options.
      # Note that you should not paste the output of `ghostty +show-config
      # --default` into your config: some default options actually conflict with each other
      # when explicitly set in a configuration file. Instead, only set the
      # options you actually need.
      #
      # Run `ghostty +show-config --default --docs` to view a list of
      # all available config options and their default values.
      #
      # Additionally, each config option is also explained in detail
      # on Ghostty's website, at https://ghostty.org/docs/config.
      #
      # Ghostty can reload the configuration while running by using the menu
      # options or the bound key (default: Command + Shift + comma on macOS and
      # Control + Shift + comma on other platforms). Not all config options can be
      # reloaded while running; some only apply to new windows and others may require
      # a full restart to take effect.

      # Config syntax crash course
      # ==========================
      # # The config file consists of simple key-value pairs,
      # # separated by equals signs.
      # font-family = Iosevka
      # window-padding-x = 2
      #
      # # Spacing around the equals sign does not matter.
      # # All of these are identical:
      # key=value
      # key= value
      # key =value
      # key = value
      #
      # # Any line beginning with a # is a comment. It's not possible to put
      # # a comment after a config option, since it would be interpreted as a
      # # part of the value. For example, this will have a value of "#123abc":
      # background = #123abc
      #
      # # Empty values are used to reset config keys to default.
      # key =
      #
      # # Some config options have unique syntaxes for their value,
      # # which is explained in the docs for that config option.
      # # Just for example:
      # resize-overlay-duration = 4s 200ms

      # background = 24273a
      # foreground = cad3f5

      font-family = "JetbrainsMono Nerd Font"

      theme = catppuccin-macchiato.conf
      font-size = 14

      window-height = 25
      window-width = 113
      window-decoration = client
      window-subtitle = working-directory
      window-show-tab-bar = always

      keybind = f11=toggle_fullscreen

      mouse-scroll-multiplier = 0.8

      link-url = true

      confirm-close-surface = false

      gtk-wide-tabs = false
      # gtk-titlebar = true

      maximize = true

      cursor-style = bar

      scrollbar = system
    '';

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
  };
}
