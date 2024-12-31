;;
;; basic configuration
;;

(load-theme 'leuven)

;; kill annoying ui elements
(menu-bar-mode -1) ; disable menu bar
(tooltip-mode -1) ; disable tool tips
(setq make-backup-files nil) ; disable backup files

;; set line numbers
(column-number-mode) ; show column number in mode line
(global-display-line-numbers-mode 1) ; show line numbers in all buffers
(setq display-line-numbers-type 'relative) ; show relative line numbers

;; kill useless and annoying buffers
(defun remove-scratch-buffer ()
  (if (get-buffer "*scratch*")
    (kill-buffer "*scratch*")))
(defun remove-message-buffer ()
  (if (get-buffer "*Messages*")
    (kill-buffer "*Messages*")))
(defun remove-compile-buffer ()
  (if (get-buffer "*Async-native-compile-log*")
    (kill-buffer "*Async-native-compile-log*")))
;;
(setq initial-scratch-message "") ; clear scratch buffer
(setq-default message-log-max nil) ; clear message buffer
(add-hook 'after-change-major-mode-hook 'remove-scratch-buffer)
(add-hook 'after-change-major-mode-hook 'remove-compile-buffer)
(add-hook 'after-change-major-mode-hook 'remove-message-buffer)

;; analyze startup performance
;; since we killed the message buffer we don't see the message
(defun efs/display-startup-time ()
  (message "Emacs started in %s."
    (format "%.2f seconds"
      (float-time (time-subtract after-init-time before-init-time)))))
;;
(add-hook 'emacs-startup-hook #'efs/display-startup-time)

;;
;; package management
;;

(require 'package)
(setq package-archives
  '(("melpa" . "https://melpa.org/packages/")
    ("org" . "https://orgmode.org/elpa/")
    ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package ivy
  :diminish
  :bind
   (("<f4>" . swiper)
    :map ivy-minibuffer-map
    ("TAB" . ivy-alt-done)
    ("C-l" . ivy-alt-done)
    ("C-j" . ivy-next-line)
    ("C-k" . ivy-previous-line)
    :map ivy-switch-buffer-map
    ("C-k" . ivy-previous-line)
    ("C-l" . ivy-done)
    ("C-d" . ivy-switch-buffer-kill)
    :map ivy-reverse-i-search-map
    ("C-k" . ivy-previous-line)
    ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package swiper)

(use-package ivy-rich
  :after ivy
  :init (ivy-rich-mode 1))

(use-package counsel
  :after ivy
  :config (counsel-mode 1))

(use-package ivy-prescient
  :after counsel
  :config (ivy-prescient-mode 1))

(use-package evil
  :config (evil-mode 1))

(use-package evil-leader
  :after evil
  :config (global-evil-leader-mode))

(use-package which-key
  :defer 3
  :diminish which-key-mode
  :config (which-key-mode)(setq which-idle-key-delay 1))

(use-package fill-column-indicator
  :config (global-display-fill-column-indicator-mode))

(use-package highlight-indent-guides
  :hook ((prog-mode) . (highlight-indent-guides))
  :config
  (setq highlight-indent-guides-method 'character))

(use-package lsp-mode
  :hook (rust-mode . lsp-deferred)
  :commands (lsp lsp-deferred))

(use-package company
  :after lsp-mode)

(use-package rust-mode
  :mode "\\.rs\\'"
  :config (setq rust-format-on-save t))

;;
;; advanced configuration
;;

(electric-pair-mode 1) ; auto complete pairs of () [] etc.
(set-terminal-coding-system 'utf-8) ; utf-8 rendering support
(setq gc-cons-threshold (* 50 1000 1000)) ; delay garbage collector
(setq ivy-re-builders-alist '((t . ivy--regex-fuzzy))) ; use fuzzy search [critical]

;;
;; key bindings
;;

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(global-set-key (kbd "<f2>") (lambda() (interactive)(save-buffer)(evil-normal-state)))
(global-set-key (kbd "<f7>") 'previous-buffer)
(global-set-key (kbd "<f8>") 'next-buffer)
(global-set-key (kbd "<f9>") 'execute-extended-command)
(global-set-key (kbd "<f12>") 'kill-emacs)

(evil-global-set-key 'motion "j" 'evil-next-visual-line)
(evil-global-set-key 'motion "k" 'evil-previous-visual-line)
(define-key evil-normal-state-map (kbd "a") 'evil-append-line)
(define-key evil-normal-state-map (kbd "s") 'swiper)

(evil-leader/set-leader "<SPC>")
(evil-leader/set-key
  "s" 'swiper
  "f" 'find-file
  "w" 'switch-to-buffer
  "k" 'kill-buffer)

;; what the hecc is this?
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(rust-mode evil ivy)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
