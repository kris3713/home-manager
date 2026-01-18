{ pkgs, ... }: {
  # DOOM Emacs
  programs.doom-emacs = {
    enable = true;
    emacs = pkgs.emacs-pgtk;
    doomDir = ./.;
    extraPackages = epkgs: with epkgs; [
      catppuccin-theme
    ];
  };
}
