(setq rmh-elfeed-org-files (list "~/.dotfiles/private/org/config/rss.org"))


(setq-default elfeed-search-filter "@6months")

(after! elfeed
  ;; Mark all YouTube entries
  (add-hook 'elfeed-new-entry-hook
            (elfeed-make-tagger :feed-url "youtube\\.com"
                                :add '(video youtube)))

  ;; Entries older than 2 weeks are tagged as read
  (add-hook 'elfeed-new-entry-hook
            (elfeed-make-tagger :before "2 weeks ago"
                                :remove 'unread))

  (add-hook 'elfeed-new-entry-hook
            (elfeed-make-tagger :feed-url "example\\.com"
                                :entry-title '(not "something interesting")
                                :add 'junk
                                :remove 'unread))

  (setf url-queue-timeout 30))
