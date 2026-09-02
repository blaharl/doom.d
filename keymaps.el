(map! :leader
      (:prefix ("o" . "open")
       :desc "Open URL in EWW (new buffer)" "l" #'+user/eww-open-in-new-buffer
       :desc "yt-dlp" "y" #'+user/yt-dlp
       :desc "yt-dlp sub" "s" #'+user/yt-dlp-sub
       :desc "mpv" "v" #'+user/mpv
       :desc "Save link" "m" #'+user/save-link))

(defun +user/eww-open-in-new-buffer ()
  "Open the URL at point in a new EWW buffer on the right (vertical 50% split)."
  (interactive)
  (require 'eww)
  (unwind-protect
      (progn
        (advice-remove #'eww '+eww-open-in-fullscreen-if-interactive-a)
        (with-popup-rules! '(((or "^\\*eww" (major-mode . eww-mode))
                              :side right :size 0.5 :select t :quit other :ttl nil))
          (eww-open-in-new-buffer)))
    (advice-add #'eww :around #'+eww-open-in-fullscreen-if-interactive-a)))


(defun +user/elfeed-entry ()
  "Return the current elfeed entry (show or search buffer), or nil."
  (cond ((derived-mode-p 'elfeed-show-mode) elfeed-show-entry)
        ((derived-mode-p 'elfeed-search-mode)
         (elfeed-search-selected :ignore-marked))))

(defun +user/get-url-at-point ()
  "Return the URL at point, or the current elfeed entry's link."
  (or (when-let* ((entry (+user/elfeed-entry)))
        (elfeed-entry-link entry))
      (thing-at-point 'url t)))

(defun +user/mpv ()
  "mpv link"
  (interactive)
  (let ((url (+user/get-url-at-point)))
    (unless url
      (user-error "No URL at point or in elfeed entry"))
    (async-shell-command
     (format "mpv %s"
             (shell-quote-argument url)))))

(defun +user/yt-dlp ()
  "dl link with yt-dlp to ~/Videos/emacs/."
  (interactive)
  (let ((url (+user/get-url-at-point)))
    (unless url
      (user-error "No URL at point or in elfeed entry"))
    (async-shell-command
     (format "yt-dlp -P ~/Videos/emacs/ %s"
             (shell-quote-argument url)))))

(defun +user/yt-dlp-sub ()
  "dl link with yt-dlp to ~/Videos/emacs/ with subs."
  (interactive)
  (let ((url (+user/get-url-at-point)))
    (unless url
      (user-error "No URL at point or in elfeed entry"))
    (async-shell-command
     (format "yt-dlp -P ~/Videos/emacs/ --embed-subs --write-auto-subs --sub-langs en --sponsorblock-remove all %s"
             (shell-quote-argument url)))))

(defun +user/save-link ()
  "Append the current entry's title and link as a markdown link to links.md."
  (interactive)
  (let* ((entry (+user/elfeed-entry))
         (title (and entry (elfeed-entry-title entry)))
         (url (+user/get-url-at-point))
         (title (or title (and url (file-name-nondirectory (directory-file-name url))) "untitled"))
         (file "~/.dotfiles/private/org/links.md"))
    (unless url
      (user-error "No URL at point or in elfeed entry"))
    (with-temp-buffer
      (insert (format "- [%s](%s)\n" title url))
      (append-to-file (point-min) (point-max) file))
    (message "Saved link: %s" url)))

(map! :n "<f5>" #'quickrun)
