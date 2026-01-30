;;; config.el -*- lexical-binding: t; -*-

;; Enable lsp
(after! lsp-ui
  (setq lsp-ui-doc-enable t))

;; Theme
(setq catppuccin-flavor 'macchiato)
(setq doom-theme 'catppuccin)

;; Set font
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 14.0 :weight 'medium))

(provide 'config)
