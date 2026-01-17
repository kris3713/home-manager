{
  ## flakes
  config,
  ## user-defined variables
  pkgs,
  ## non-flakes
  catppuccin-ghostty-theme,
  catppuccin-btop-theme,
  catppuccin-bat-theme,
  catppuccin-lsd-theme,
  catppuccin-delta-theme,
  catppuccin-micro-theme,
  ...
}: let
  configHome = config.home;
  inherit (configHome) homeDirectory;

  userBinDir = "${homeDirectory}/.local/bin";
  userConfigDir = "${homeDirectory}/.config";
in {
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

    "${userConfigDir}/bat/config".text = /* sh */ ''
      --theme='Catppuccin Macchiato'
      --style='numbers'
    '';

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
}
