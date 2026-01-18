_: {
  # DOOM Emacs
  programs.doom-emacs = {
    enable = true;
    doomDir = ./.;
    extraPackages = epkgs: with epkgs; [
      catppuccin-theme
    ];
  };
}
