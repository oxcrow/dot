;;
;; basic configuration
;;

;; set global keys
;; we do this at the beginning so in case we mess up our emac config
;; we at least have some basic features that we can use to recover
;; from the broken state
(global-set-key (kbd "<f12>") 'kill-this-buffer)
(global-set-key (kbd "S-<f12>") 'tab-bar-close-tab)
(global-set-key (kbd "C-<f12>") 'kill-emacs)
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(global-set-key (kbd "<f2>") (lambda() (interactive)(evil-normal-state)(beacon-blink)(save-buffer)))
(global-set-key (kbd "<f3>") 'projectile-find-file)
(global-set-key (kbd "<f7>") 'tab-bar-switch-to-prev-tab)
(global-set-key (kbd "<f8>") 'tab-bar-switch-to-next-tab)
(global-set-key (kbd "S-<f7>") 'previous-buffer)
(global-set-key (kbd "S-<f8>") 'next-buffer)
(global-set-key (kbd "<f9>") 'execute-extended-command)
(global-set-key (kbd "S-<f9>") 'eval-expression)
(global-set-key (kbd "C-<f9>") (lambda() (interactive) (eval-expression (load-file user-init-file))))

;; load themes
(load-theme 'leuven)
;;
;;(add-to-list 'custom-theme-load-path "~/.config/emacs/etc/themes/")
;;(load-theme 'infrared 1)

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

(use-package evil-surround
  :after evil
  :config (global-evil-surround-mode 1))

(use-package avy
  :after evil
  :config
  (setq avy-keys '(?a ?s ?d ?f ?g ?h ?i ?j ?k ?l))
  (setq avy-orders-alist
        '((avy-goto-line . avy-order-closest)
          (avy-goto-word-0 . avy-order-closest)
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
  (setq highlight-indent-guides-character ?\x250A)
  (set-face-foreground 'highlight-indent-guides-character-face "dimgray")
  (setq highlight-indent-guides-method 'character))

(use-package beacon
  :commands(beacon-blink))

(use-package doom-modeline
  :config
  (setq doom-modeline-icon nil) ; disable icons
  (doom-modeline-mode 1))

(use-package adaptive-wrap
  :config
  (setq-default adaptive-wrap-extra-indent 4)
  (defun turn-on-adaptive-wrap-prefix-mode ()
      "Turns on adaptive-wrap-prefix-mode."
      (interactive)
      (adaptive-wrap-prefix-mode 1))
    (define-globalized-minor-mode global-adaptive-wrap-prefix-mode
      adaptive-wrap-prefix-mode
      turn-on-adaptive-wrap-prefix-mode)
    (global-adaptive-wrap-prefix-mode 1))

(use-package projectile
  :commands (projectile-find-file))

(use-package lsp-mode
  :hook ((rust-mode c-mode c++-mode tuareg-mode go-mode) . lsp-deferred)
  :commands (lsp lsp-deferred)
  :config
  (setq lsp-headerline-breadcrumb-enable nil)  ;; disable ugly breadcumb headerline
  (setq lsp-modeline-code-actions-enable nil) ;; disable the ugly modeline information
  (setq lsp-enable-links nil) ;; disable ugly underlines under c includes
  (setq lsp-ui-doc-enable 1) ; BUG:; not sure if this even works
  (setq lsp-enable-symbol-highlighting nil) ;; disable ugly symbol highligths and underlnes
  (setq completion-ignore-case 1)) ;; disable case sensitive completion at point

(with-eval-after-load 'lsp-mode
  (add-to-list 'lsp-language-id-configuration '(".*\\.md$" . "ask")))
(with-eval-after-load 'lsp-mode
  (lsp-register-client (make-lsp-client
                        :new-connection (lsp-stdio-connection "ask")
                        :activation-fn (lsp-activate-on "ask")
                        :server-id 'ask)))

(use-package corfu
  :after lsp-mode
  :config (global-corfu-mode))

(use-package format-all
  :commands (format-all-buffer format-all-buffers)
  :config
  (setq-default format-all-formatters '(("C" (clang-format))
                                        ("C++" (clang-format))
                                        ("Rust" (rustfmt))
                                        ("OCaml" (ocamlformat))
                                        ("Haskell" (ormolu))
                                        ("Go" (gofmt)))))

(use-package rust-mode
  :mode "\\.rs\\'"
  :config
  (add-hook 'before-save-hook #'format-all-buffer))

(use-package tuareg
  :mode ("\\.ml\\'" . tuareg-mode)
  :config
  (add-hook 'before-save-hook #'format-all-buffer))

(use-package merlin
  :after tuareg
  :config(merlin-mode))

(use-package haskell-mode
  :mode ("\\.hs\\'" . haskell-mode))

(use-package lsp-haskell
  :after haskell-mode)

(use-package go-mode
  :mode ("\\.go\\'" . go-mode))

;;
;; hooks
;;

(add-hook 'before-save-hook #'format-all-buffer)

;;
;; advanced configuration
;;

;; kill annoying ui elements
(menu-bar-mode -1) ; disable menu bar
(tooltip-mode -1) ; disable tool tips
(setq make-backup-files nil) ; disable backup files

;; reconfigure mode line because everything looks ugly by default.
;; specifically emacs minor modes makes my mode line  ugly as fuck
;; by adding annoying information about the current lsp, ivy, and
;; other thousand different god knows what kind of garbage dogshit
;; worthless minor modes that i never asked for!
;; fuck all of them!
(setq-default mode-line-format (delq 'mode-line-modes mode-line-format))

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
(setq gc-cons-threshold (* 50 1000 1000)) ; delay garbage collector
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

;; configure eww browser
(setq-default shr-max-width 80) ; to set max column width as 100
(global-set-key (kbd "S-<f5>") 'eww-readable)

;;
;; key bindings
;;

(define-key evil-normal-state-map (kbd "<escape>") (lambda() (interactive)(evil-normal-state)(beacon-blink)))
(evil-global-set-key 'motion "j" 'evil-next-visual-line)
(evil-global-set-key 'motion "k" 'evil-previous-visual-line)
(define-key evil-normal-state-map (kbd "a") 'evil-append-line)
(define-key evil-normal-state-map (kbd "s") 'swiper)
(define-key evil-normal-state-map (kbd ",") 'avy-goto-word-0)
(define-key evil-normal-state-map (kbd "f") (lambda() (interactive)(avy-goto-word-0 nil (line-beginning-position) (line-end-position))))
(define-key evil-normal-state-map (kbd "t") 'avy-goto-char-timer)

(define-key evil-normal-state-map (kbd "K") 'lsp-describe-thing-at-point)

(evil-leader/set-leader "<SPC>")
(evil-leader/set-key
  "<SPC>" 'switch-to-buffer
  "s" 'swiper
  "w" 'other-window
  "l" 'avy-goto-line
  "r" 'lsp-rename
  "f" 'format-all-buffer
  "k" 'kill-buffer
  "t" 'tab-bar-new-tab
  "o" 'projectile-find-file)

;; what the hecc is this?
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(doom-modeline adaptive-wrap rust-mode evil ivy)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
