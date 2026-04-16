{
  ## defaults
  config,
  lib,
  ## user-defined variables
  # pkgs,
  determinateNix,
  ...
}: let
  # important variables
  # hm = lib.hm;
  inherit (lib) mkForce;

  inherit (config.home) username homeDirectory;

  # other variables
  userDataDir = "${homeDirectory}/.local/share";
  userStateDir = "${homeDirectory}/.local/state";
  userConfigDir = "${homeDirectory}/.config";
in {
  nix = {
    package = determinateNix.nix;
    settings = {
      extra-substituters = [
        "https://cache.numtide.com"
        "https://cache.nixos-cuda.org"
        "https://nix-community.cachix.org/"
      ];
      extra-trusted-public-keys = [
        "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
        "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  # Ensure that non-free packages are allowed,
  # and CUDA support is enabled
  nixpkgs = {
    config = {
      allowUnfree = true;
      cudaSupport = true;
    };
  };

  home = {
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
      # EZA_ICONS_AUTO
      EZA_ICONS_AUTO = "always";
    };
  };

  # Silence news completely.
  news = {
    display = "silent";
    json = mkForce {};
    entries = mkForce [];
  };
}
