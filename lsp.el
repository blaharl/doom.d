;;; lsp.el -*- lexical-binding: t; -*-

(use-package! typst-ts-mode
  :mode "\\.typ\\'"
  :init
  (add-hook 'typst-ts-mode-local-vars-hook #'lsp! 'append))
