{
  ## defaults
  config,
  lib,
  # user-defined variables
  # pkgs,
  # determinateNix,
  ...
}: let
  # important variables
  # hm = lib.hm;
  inherit (lib) mkForce;
  configHome = config.home;
  inherit (configHome) username;
  inherit (configHome) homeDirectory;

  # other variables
  userDataDir = "${homeDirectory}/.local/share";
  userStateDir = "${homeDirectory}/.local/state";
  userConfigDir = "${homeDirectory}/.config";
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
    stateVersion = "26.05"; # Please read the comment before changing.

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
