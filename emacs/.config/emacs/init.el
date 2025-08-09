;;
;; basic configuration
;;
(setq-default oxcrow-editing-mode 0) ; 0 for evil, 1 for meow

;;
;; mode agnostic functions
;;

(defun oxcrow-normal-state ()
  (if (eq oxcrow-editing-mode 0) (evil-normal-state) (meow-normal-mode)))


;; set global keys
;; we do this at the beginning so in case we mess up our emac config
;; we at least have some basic features that we can use to recover from the broken state
(global-set-key (kbd "<f12>") 'kill-current-buffer)
(global-set-key (kbd "S-<f12>") 'tab-bar-close-tab)
(global-set-key (kbd "C-<f12>") 'kill-emacs)
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(global-set-key (kbd "<f2>") (lambda() (interactive) (oxcrow-normal-state)(save-buffer)(delete-other-windows)))
(global-set-key (kbd "<f3>") 'projectile-find-file)
(global-set-key (kbd "<f7>") 'tab-bar-switch-to-prev-tab)
(global-set-key (kbd "<f8>") 'tab-bar-switch-to-next-tab)
(global-set-key (kbd "S-<f7>") 'previous-buffer)
(global-set-key (kbd "S-<f8>") 'next-buffer)
(global-set-key (kbd "<f9>") 'execute-extended-command)
(global-set-key (kbd "S-<f9>") 'eval-expression)
(global-set-key (kbd "C-<f9>") (lambda() (interactive) (eval-expression (load-file user-init-file))))
(xterm-mouse-mode 1)


;; load themes
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
(use-package nerd-icons)

(use-package catppuccin-theme
  ;; :init
  ;; (setq catppuccin-flavor 'latte)
  ;; (load-theme 'catppuccin 1)
)

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

(use-package yasnippet
  :config
  (yas-global-mode 1))

(use-package ivy-rich
  :after ivy
  :init (ivy-rich-mode 1))

(use-package counsel
  :after ivy
  :config
  (setq counsel-grep-base-command "rg -i -M 120 --no-heading --line-number --color never '%s' %s")
  (counsel-mode 1))

(use-package ivy-prescient
  :after counsel
  :config (ivy-prescient-mode 1))

(use-package evil
  :init
  (setq evil-want-C-u-scroll t)
  (setq evil-want-fine-undo t)
  :config
  (evil-mode (if (eq oxcrow-editing-mode 0) 1 0)))

(use-package meow)
(defun meow-setup ()
  (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
  (meow-motion-define-key
   '("j" . meow-next)
   '("k" . meow-prev)
   '("<escape>" . ignore))
  (meow-leader-define-key
   ;; Use SPC (0-9) for digit arguments.
   '("1" . meow-digit-argument)
   '("2" . meow-digit-argument)
   '("3" . meow-digit-argument)
   '("4" . meow-digit-argument)
   '("5" . meow-digit-argument)
   '("6" . meow-digit-argument)
   '("7" . meow-digit-argument)
   '("8" . meow-digit-argument)
   '("9" . meow-digit-argument)
   '("0" . meow-digit-argument)
   '("/" . meow-keypad-describe-key)
   '("?" . meow-cheatsheet))
  (meow-normal-define-key
   '("0" . meow-expand-0)
   '("9" . meow-expand-9)
   '("8" . meow-expand-8)
   '("7" . meow-expand-7)
   '("6" . meow-expand-6)
   '("5" . meow-expand-5)
   '("4" . meow-expand-4)
   '("3" . meow-expand-3)
   '("2" . meow-expand-2)
   '("1" . meow-expand-1)
   '("-" . negative-argument)
   '(";" . meow-reverse)
   '("," . meow-inner-of-thing)
   '("." . meow-bounds-of-thing)
   '("[" . meow-beginning-of-thing)
   '("]" . meow-end-of-thing)
   '("a" . meow-append)
   '("A" . meow-open-below)
   '("b" . meow-back-word)
   '("B" . meow-back-symbol)
   '("c" . meow-change)
   '("d" . meow-delete)
   '("D" . meow-backward-delete)
   '("e" . meow-next-word)
   '("E" . meow-next-symbol)
   '("f" . meow-find)
   '("g" . meow-cancel-selection)
   '("G" . meow-grab)
   '("h" . meow-left)
   '("H" . meow-left-expand)
   '("i" . meow-insert)
   '("I" . meow-open-above)
   '("j" . meow-next)
   '("J" . meow-next-expand)
   '("k" . meow-prev)
   '("K" . meow-prev-expand)
   '("l" . meow-right)
   '("L" . meow-right-expand)
   '("m" . meow-join)
   '("n" . meow-search)
   '("o" . meow-block)
   '("O" . meow-to-block)
   '("p" . meow-yank)
   '("q" . meow-quit)
   '("Q" . meow-goto-line)
   '("r" . meow-replace)
   '("R" . meow-swap-grab)
   '("s" . meow-kill)
   '("t" . meow-till)
   '("u" . meow-undo)
   '("U" . meow-undo-in-selection)
   '("v" . meow-visit)
   '("w" . meow-mark-word)
   '("W" . meow-mark-symbol)
   '("x" . meow-line)
   '("X" . meow-goto-line)
   '("y" . meow-save)
   '("Y" . meow-sync-grab)
   '("z" . meow-pop-selection)
   '("'" . repeat)
   '("<escape>" . ignore)))
(require 'meow)
(meow-setup)
(meow-global-mode (if (eq oxcrow-editing-mode 1) 1 0))

(use-package evil-leader
  :after evil
  :config (global-evil-leader-mode))

(use-package evil-surround
  :after evil
  :config (global-evil-surround-mode 1))

(use-package avy
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
  :config
  (setq-default display-fill-column-indicator-column 80)
  (global-display-fill-column-indicator-mode))

(use-package highlight-indent-guides
  :hook ((prog-mode) . (highlight-indent-guides))
  :config
  (setq highlight-indent-guides-character ?\x250A)
  (set-face-foreground 'highlight-indent-guides-character-face "dimgray")
  (setq highlight-indent-guides-method 'character))

(use-package doom-modeline
  :config
  (setq doom-modeline-icon nil) ; disable icons
  (doom-modeline-mode 1))

(use-package projectile
  :commands (projectile-find-file))

(use-package lsp-mode
  :hook ((zig-mode rust-mode c-mode c++-mode tuareg-mode) . lsp-deferred)
  :commands (lsp lsp-deferred)
  :config
  (setq lsp-headerline-breadcrumb-enable nil)  ;; disable ugly breadcumb headerline
  (setq lsp-modeline-code-actions-enable nil) ;; disable the ugly modeline information
  (setq lsp-enable-links nil) ;; disable ugly underlines under c includes
  (setq lsp-ui-doc-enable nil) ;; BUG:; not sure if this even works
  (setq lsp-enable-symbol-highlighting nil) ;; disable ugly symbol highligths and underlnes
  (setq completion-ignore-case 1) ;; disable case sensitive completion at point
  ;; (setq lsp-diagnostics-provider :none) ;; disable lsp error diagnostics (it's annoying in ocaml)
  ;; (setq evil-normal-state-tag (propertize "NOR" 'face '(:background "blue" :foreground "white")))
  ;; (setq evil-insert-state-tag (propertize "INS" 'face '(:background "blue" :foreground "white")))
  ;; (setq evil-visual-state-tag (propertize "VIS" 'face '(:background "blue" :foreground "white")))
  )

(with-eval-after-load 'lsp-mode
  (add-to-list 'lsp-language-id-configuration '(".*\\.md$" . "ask")))
(with-eval-after-load 'lsp-mode
  (lsp-register-client (make-lsp-client
                        :new-connection (lsp-stdio-connection "ask")
                        :activation-fn (lsp-activate-on "ask")
                        :server-id 'ask)))

(use-package company
  :init
  (global-company-mode))

(use-package format-all
  :commands (format-all-buffer format-all-buffers)
  :config
  (setq-default format-all-formatters '(("C" (clang-format))
                                        ("C++" (clang-format))
                                        ("Rust" (rustfmt))
                                        ("OCaml" (ocamlformat)))))

(use-package zig-mode
  :mode "\\.zig\\'"
  :config
  (setq lsp-zig-zls-executable "~/.local/share/nvim/mason/bin/zls")
  (setq lsp-zig-zig-exe-path "/snap/bin/zig")
  (add-hook 'before-save-hook #'format-all-buffer))

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
(setq gc-cons-threshold (* 100 1000 1000)) ; delay garbage collector
(setq read-process-output-max (* 50  1000  1000)) ; increase max data read from LSP process
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
;;(add-hook 'after-change-major-mode-hook 'remove-scratch-buffer)
;;(add-hook 'after-change-major-mode-hook 'remove-message-buffer)
;;(add-hook 'after-change-major-mode-hook 'remove-compile-buffer)

;; configure eww browser
(setq-default shr-max-width 80) ; to set max column width as 100
(global-set-key (kbd "S-<f5>") 'eww-readable)

;;
;; key bindings
;;

;; (evil-global-set-key 'motion "j" 'evil-next-visual-line)
;; (evil-global-set-key 'motion "k" 'evil-previous-visual-line)
(define-key evil-normal-state-map (kbd "a") 'evil-append-line)
(define-key evil-normal-state-map (kbd "s") 'swiper)
(define-key evil-normal-state-map (kbd "t") 'avy-goto-word-0)
(define-key evil-normal-state-map (kbd "f") (lambda() (interactive)(avy-goto-word-0 nil (line-beginning-position) (line-end-position))))
(define-key evil-normal-state-map (kbd ",") 'avy-goto-char-timer)
(define-key evil-normal-state-map (kbd "]d") 'flymake-goto-next-error)
(define-key evil-normal-state-map (kbd "[d") 'flymake-goto-prev-error)
(define-key evil-normal-state-map (kbd "C-j") 'evil-scroll-down)
(define-key evil-normal-state-map (kbd "C-k") 'evil-scroll-up)

(define-key evil-normal-state-map (kbd "K") 'lsp-describe-thing-at-point)

(evil-leader/set-leader "<SPC>")
(evil-leader/set-key
  "<SPC>" 'switch-to-buffer
  "s" 'swiper
  "w" 'other-window
  "l" 'avy-goto-line
  "r" 'lsp-rename
  "f" 'projectile-find-file
  "k" 'kill-buffer
  "t" 'tab-bar-new-tab
  "o" 'delete-other-windows
  "c" 'comment-line)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
