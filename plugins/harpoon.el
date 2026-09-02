;; On vanilla (You can use another prefix instead C-c h)

;; You can use this hydra menu that have all the commands
(global-set-key (kbd "C-c a") 'harpoon-quick-menu-hydra)
(global-set-key (kbd "C-c h <return>") 'harpoon-add-file)

;; And the vanilla commands
(global-set-key (kbd "C-c h f") 'harpoon-toggle-file)
(global-set-key (kbd "C-c h h") 'harpoon-toggle-quick-menu)
(global-set-key (kbd "C-c h c") 'harpoon-clear)
(global-set-key (kbd "C-c h 1") 'harpoon-go-to-1)
(global-set-key (kbd "C-c h 2") 'harpoon-go-to-2)
(global-set-key (kbd "C-c h 3") 'harpoon-go-to-3)
(global-set-key (kbd "C-c h 4") 'harpoon-go-to-4)
(global-set-key (kbd "C-c h 5") 'harpoon-go-to-5)
(global-set-key (kbd "C-c h 6") 'harpoon-go-to-6)
(global-set-key (kbd "C-c h 7") 'harpoon-go-to-7)
(global-set-key (kbd "C-c h 8") 'harpoon-go-to-8)
(global-set-key (kbd "C-c h 9") 'harpoon-go-to-9)

;; On doom emacs

(map! :leader "j q" 'harpoon-quick-menu-hydra)
(map! :leader "j a" 'harpoon-add-file)
(map! :leader "j c" 'harpoon-clear)
(map! :leader "j f" 'harpoon-toggle-file)
(map! :leader "1" 'harpoon-go-to-1)
(map! :leader "2" 'harpoon-go-to-2)
(map! :leader "3" 'harpoon-go-to-3)
(map! :leader "4" 'harpoon-go-to-4)
(map! :leader "5" 'harpoon-go-to-5)
(map! :leader "6" 'harpoon-go-to-6)
(map! :leader "7" 'harpoon-go-to-7)
(map! :leader "8" 'harpoon-go-to-8)
(map! :leader "9" 'harpoon-go-to-9)
