(map! :leader
      (:prefix ("o" . "open")
       :desc "Open URL/HTML in EWW (new buffer)" "l" #'+user/eww-open-in-new-buffer
       :desc "yt-dlp" "y" #'+user/yt-dlp
       :desc "yt-dlp sub" "s" #'+user/yt-dlp-sub
       :desc "Play URL/video with mpv" "v" #'+user/mpv
       :desc "Save link" "m" #'+user/save-link))

(defun +user/eww-open-in-new-buffer ()
  "Open a Dired HTML file or URL in a new EWW buffer on the right."
  (interactive)
  (require 'eww)
  (let ((file (and (derived-mode-p 'dired-mode)
                   (dired-get-filename nil t))))
    (unwind-protect
        (progn
          (advice-remove #'eww '+eww-open-in-fullscreen-if-interactive-a)
          (with-popup-rules! '(((or "^\\*eww" (major-mode . eww-mode))
                                :side right :size 0.5 :select t :quit other :ttl nil))
            (if (and file
                     (file-regular-p file)
                     (member (downcase (or (file-name-extension file) ""))
                             '("htm" "html" "png" "jpeg" "jpg" "gif" "webp")))
                (eww-open-file file t)
              (eww-open-in-new-buffer))))
      (advice-add #'eww :around #'+eww-open-in-fullscreen-if-interactive-a))))


(defun +user/elfeed-entry ()
  "Return the current elfeed entry (show or search buffer), or nil."
  (cond ((derived-mode-p 'elfeed-show-mode) elfeed-show-entry)
        ((derived-mode-p 'elfeed-search-mode)
         (elfeed-search-selected :ignore-marked))))

(defun +user/get-url-at-point ()
  "Return the URL at point, or the current elfeed entry's link."
  (or (when (fboundp 'shr-url-at-point)
        (shr-url-at-point nil))
      (thing-at-point 'url t)
      (when-let* ((entry (+user/elfeed-entry)))
        (elfeed-entry-link entry))))

(defun +user/mpv ()
  "Play a Dired video file with EMPV, or the URL at point with mpv."
  (interactive)
  (let ((file (and (derived-mode-p 'dired-mode)
                   (dired-get-filename nil t))))
    (if (and file
             (file-regular-p file)
             (progn
               (require 'empv)
               (member (downcase (or (file-name-extension file) ""))
                       (mapcar #'downcase empv-video-file-extensions))))
        (let ((empv-mpv-args
               (seq-remove (lambda (arg) (equal arg "--no-video"))
                           empv-mpv-args)))
          (empv-play file)
          (empv--send-command
           '("get_property" "video")
           (lambda (video)
             (when (eq video :json-false)
               (empv-toggle-video)))))
      (let ((url (+user/get-url-at-point)))
        (unless url
          (user-error "No URL at point or in elfeed entry"))
        (async-shell-command
         (format "mpv %s"
                 (shell-quote-argument url)))))))

(defun +user/yt-dlp ()
  "dl link with yt-dlp to ~/Videos/emacs/."
  (interactive)
  (let ((url (+user/get-url-at-point)))
    (unless url
      (user-error "No URL at point or in elfeed entry"))
    (async-shell-command
     (format "yt-dlp -P ~/Videos/emacs/ --sponsorblock-remove all %s"
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
         (file "~/.dotfiles/private/org/bookmarks/rss.md"))
    (unless url
      (user-error "No URL at point or in elfeed entry"))
    (with-temp-buffer
      (insert (format "- [%s](%s)\n" title url))
      (append-to-file (point-min) (point-max) file))
    (message "Saved link: %s" url)))

(map! :n "<f5>" #'quickrun)
