;;
;; basic configuration
;;

(load-theme 'leuven)

;; set cursor
(global-hl-line-mode 1) ; highlight current line

;; set line numbers
(column-number-mode) ; show column number in mode line
(global-display-line-numbers-mode 1) ; show line numbers in all buffers
(setq display-line-numbers-type 'relative) ; show relative line numbers

;; set indentation and tab behavior
(setq-default indent-tabs-mode nil) ; always use spaces instead of tabs for indentation everywhere posible
(setq-default tab-width 4) ; use 4 spaces per tabs everywhere possible
(defvaralias 'c-basic-offset 'tab-width) ; set tabwidth for c like languages
(setq tab-always-indent 'complete) ; enable auto-completion by pressing tab

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
  :bind (("C-s" . swiper)
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
  (setq evil-want-fine-undo t)
  :config
  (evil-mode 1))

(use-package evil-leader
  :after evil
  :config (global-evil-leader-mode))

(use-package avy
  :after evil
  :config
  (setq avy-keys (number-sequence ?a ?z))
  (setq avy-orders-alist
      '((avy-goto-line . avy-order-closest)
        (avy-goto-char-timer . avy-order-closest))))

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

(use-package beacon
  :commands(beacon-blink))

(use-package projectile
  :commands (projectile-find-file))

(use-package lsp-mode
  :hook ((rust-mode c-mode c++-mode tuareg-mode) . lsp-deferred)
  :commands (lsp lsp-deferred))

(use-package corfu
  :after lsp-mode
  :config (global-corfu-mode))

(use-package format-all
  :commands (format-all-buffer format-all-buffers)
  :config
  (setq-default format-all-formatters '(("C" (clang-format))
                                        ("C++" (clang-format))
                                        ("Rust" (rustfmt))
                                        ("OCaml" (ocamlformat)))))

(use-package rust-mode
  :mode "\\.rs\\'")

(use-package tuareg
  :mode ("\\.ml\\'" . tuareg-mode))

(use-package merlin
  :after tuareg
  :config(merlin-mode))

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
(save-place-mode 1) ; save location of last cursor location

(electric-pair-mode 1) ; auto complete pairs of () [] etc.
(set-terminal-coding-system 'utf-8) ; utf-8 rendering support
(setq ivy-re-builders-alist '((swiper . ivy--regex-plus)
                              (t . ivy--regex-fuzzy))) ; ivy search patterns

(set-frame-parameter (selected-frame) 'buffer-predicate #'buffer-file-name) ; only cycle through file buffers

;; reload buffers
(global-auto-revert-mode 1) ; reload file buffers when the file changes on disk
(setq global-auto-revert-non-file-buffers t) ; reload dired buffers if files changes on disk

;; lsp hacks
(setq gc-cons-threshold (* 100 1000 1000)) ; delay garbage collector
(setq read-process-output-max (* 10  1000  1000)) ; increase max data read from LSP process
(setq lsp-log-io nil) ; do not log anything from LSP

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
(global-set-key (kbd "<f2>") (lambda() (interactive)(evil-normal-state)(beacon-blink)(save-buffer)))
(global-set-key (kbd "<f3>") 'projectile-find-file)
(global-set-key (kbd "<f7>") 'previous-buffer)
(global-set-key (kbd "<f8>") 'next-buffer)
(global-set-key (kbd "<f9>") 'execute-extended-command)
(global-set-key (kbd "S-<f9>") 'eval-expression)
(global-set-key (kbd "C-<f9>") (lambda() (interactive) (eval-expression (load-file user-init-file))))
(global-set-key (kbd "<f12>") 'kill-this-buffer)
(global-set-key (kbd "C-<f12>") 'kill-emacs)

(define-key evil-normal-state-map (kbd "<escape>") (lambda() (interactive)(evil-normal-state)(beacon-blink)))
(evil-global-set-key 'motion "j" 'evil-next-visual-line)
(evil-global-set-key 'motion "k" 'evil-previous-visual-line)
(define-key evil-normal-state-map (kbd "a") 'evil-append-line)
(define-key evil-normal-state-map (kbd "s") 'swiper)
(define-key evil-normal-state-map (kbd ",") 'avy-goto-char-timer)

(evil-leader/set-leader "<SPC>")
(evil-leader/set-key
  "<SPC>" 'switch-to-buffer
  "s" 'swiper
  "l" 'avy-goto-line
  "f" 'format-all-buffer
  "k" 'kill-buffer
  "o" 'projectile-find-file)

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
