(live-add-pack-lib "emacs-git-gutter")
(require 'git-gutter)

(setq git-gutter:window-width 2)

(global-git-gutter-mode t)

(setq git-gutter:lighter " G-+")

(setq git-gutter:modified-sign "  ")
(setq git-gutter:added-sign "++")
(setq git-gutter:deleted-sign "-- ")
(setq git-gutter:unchanged-sign "  ")

(set-face-background 'git-gutter:unchanged "black")
(set-face-background 'git-gutter:modified "#a020f0")
(set-face-foreground 'git-gutter:added "green")
(set-face-foreground 'git-gutter:deleted "red")
