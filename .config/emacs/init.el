;;
;; basic configuration
;;

(load-theme 'leuven)

;; set line numbers
(column-number-mode) ; show column number in mode line
(global-display-line-numbers-mode 1) ; show line numbers in all buffers
(setq display-line-numbers-type 'relative) ; show relative line numbers

;; set indentation
(setq-default indent-tabs-mode nil) ; always use spaces instead of tabs for indentation everywhere posible
(setq-default tab-width 4) ; use 4 spaces per tabs everywhere possible
(defvaralias 'c-basic-offset 'tab-width) ; set tabwidth for c like languages

;; analyze startup performance
;; since we killed the message buffer we don't see the message
(defun efs/display-startup-time ()
  (message
   "Emacs started in %s."
   (format "%.2f seconds"
           (float-time (time-subtract after-init-time before-init-time)))))
;;
(add-hook 'emacs-startup-hook #'efs/display-startup-time)

;;
;; package management
;;

(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package no-littering)

(use-package ivy
  :diminish
  :bind (("<f4>" . swiper)
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
  :init
  (setq evil-want-C-u-scroll t)
  :config
  (evil-mode 1))

(use-package evil-leader
  :after evil
  :config (global-evil-leader-mode))

(use-package avy
  :after evil)

(use-package which-key
  :defer 1
  :diminish which-key-mode
  :config (which-key-mode)(setq which-idle-key-delay 1))

(use-package fill-column-indicator
  :defer 1
  :config (global-display-fill-column-indicator-mode))

(use-package highlight-indent-guides
  :hook ((prog-mode) . (highlight-indent-guides))
  :config
  (setq highlight-indent-guides-method 'character))

(use-package lsp-mode
  :hook ((rust-mode c-mode c++-mode) . lsp-deferred)
  :commands (lsp lsp-deferred))

(use-package company
  :after lsp-mode)

(use-package format-all
  :commands (format-all-buffer format-all-buffers)
  :config
  (setq-default format-all-formatters '(("C" (clang-format))
                                        ("C++" (clang-format))
                                        ("Rust" (rustfmt)))))

(use-package rust-mode
  :mode "\\.rs\\'")

;;
;; hooks
;;

(add-hook 'lsp-mode-hook (setq lsp-headerline-breadcrumb-enable nil)) ; disable lsp breadcrumb header

;;
;; advanced configuration
;;

;; kill annoying ui elements
(menu-bar-mode -1) ; disable menu bar
(tooltip-mode -1) ; disable tool tips
(setq make-backup-files nil) ; disable backup files

;; kill annoying behavhiors
(setq make-backup-files nil) ; disable backup files
(setq auto-save-default nil) ; disable autosave files
(setq create-lockfiles nil) ; disable lock files

;; save history
(recentf-mode 1) ; save history of recently openend files
(savehist-mode 1) ; save history of recently used commands
(save-place-mode 1) ; save location of last cursor location

(electric-pair-mode 1) ; auto complete pairs of () [] etc.
(set-terminal-coding-system 'utf-8) ; utf-8 rendering support
(setq gc-cons-threshold (* 50 1000 1000)) ; delay garbage collector
(setq ivy-re-builders-alist '((t . ivy--regex-fuzzy))) ; use fuzzy search [critical]

(set-frame-parameter (selected-frame) 'buffer-predicate #'buffer-file-name) ; only cycle through file buffers

;; reload buffers
(global-auto-revert-mode 1) ; reload file buffers when the file changes on disk
(setq global-auto-revert-non-file-buffers t) ; reload dired buffers if files changes on disk

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
(add-hook 'after-change-major-mode-hook 'remove-message-buffer)
(add-hook 'after-change-major-mode-hook 'remove-compile-buffer)

;;
;; key bindings
;;

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(global-set-key (kbd "<f2>") (lambda() (interactive)(evil-normal-state)(save-buffer)))
(global-set-key (kbd "<f7>") 'previous-buffer)
(global-set-key (kbd "<f8>") 'next-buffer)
(global-set-key (kbd "S-<f8>") 'kill-this-buffer)
(global-set-key (kbd "<f9>") 'execute-extended-command)
(global-set-key (kbd "<f12>") 'kill-emacs)

(evil-global-set-key 'motion "j" 'evil-next-visual-line)
(evil-global-set-key 'motion "k" 'evil-previous-visual-line)
(define-key evil-normal-state-map (kbd "a") 'evil-append-line)
(define-key evil-normal-state-map (kbd "s") 'swiper)
(define-key evil-normal-state-map (kbd ",") 'avy-goto-word-1)

(evil-leader/set-leader "<SPC>")
(evil-leader/set-key
  "s" 'swiper
  "f" 'format-all-buffer
  "w" 'switch-to-buffer
  "k" 'kill-buffer
  "o" 'find-file)

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
