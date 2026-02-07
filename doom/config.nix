{ pkgs, ... }: {
  # DOOM Emacs
  programs.doom-emacs = {
    enable = false;
    emacs = pkgs.emacs-pgtk;
    doomDir = ./.;
    extraPackages = epkgs: with epkgs; [
      catppuccin-theme
      nix-mode
    ];
  };
}
