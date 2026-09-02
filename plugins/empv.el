;; (use-package empv
;;   :straight (:host github :repo "isamert/empv.el")
;;   :defer t
;;   :autoload (empv--select-action)
;;   :general
;;   (im-leader
;;     "r" empv-map
;;     "R" #'empv-hydra/body
;;     "r4" #'empv-subsonic-search)
;;   :config
;;   (require 'im-radio-channels)

;; (setq empv-radio-channels im-radio-channels)
(setq empv-radio-log-file "~/Music/mpd/radio.log")
(setq empv-base-directory "~/Videos/")
(setq empv-video-dir `("~/Videos" "~/Videos/Freetube"))
(setq empv-audio-dir `("~/Music"))
(setq empv-allow-insecure-connections t)
(setq empv-invidious-instance 'ivjs)

;; ^ see https://api.invidious.io/
(setq empv-youtube-use-tabulated-results t)
;; (add-to-list 'empv-mpv-args "--ytdl-format=bestvideo+bestaudio/best[ext=mp4]/best")
;; (add-to-list 'empv-mpv-args "--save-position-on-quit")
(setq empv-reset-playback-speed-on-quit t)
(add-hook 'empv-init-hook #'empv-override-quit-key)
(add-hook 'empv-youtube-results-mode-hook #'im-disable-line-wrapping)

;; (setq empv-subsonic-url im-navidrome-server)
;; (setq empv-subsonic-username im-navidrome-username)
;; (setq empv-subsonic-password im-navidrome-password)

;; (evil-make-overriding-map empv-youtube-results-mode-map 'normal)
;; (with-eval-after-load 'embark (empv-embark-initialize-extra-actions))
;; (with-eval-after-load 'org
;;   (add-to-list 'org-file-apps '("\\.\\(mp3\\|ogg\\)\\'" . (lambda (path _str) (empv-play-file path))))))

;; (defun im-export-radio-channels-as-m3u (file)
;;   "Export radio list into an M3U FILE."
;;   (interactive
;;    (list
;;     (read-file-name
;;      "Where to save the .m3u file?"
;;      "~/Documents/sync/"
;;      "radiolist.m3u")))
;;   (with-temp-file file
;;     (->>
;;      im-radio-channels
;;      (--map
;;       (format
;;        "#EXTINF:0, %s\n%s"
;;        (car it)
;;        ;; Replace http:// with icyx://, because VLC on Android can't
;;        ;; retrieve song name if the stream is on http://
;;        (if (s-contains? "radcap.ru" (car it))
;;            (s-replace "http://" "icyx://" (cdr it))
;;          (cdr it))))
;;      (--reduce (format "%s\n%s" acc it))
;;      (s-prepend "#EXTM3U\n")
;;      (insert))))
