;; My first custom init.el file.
;; Heavily inspired by dakrone's.
;;
;; Turn on debugging
(setq debug-on-error t)
(setq debug-on-quit t)

;; Keep track of loading time
(defconst emacs-start-time (current-time))

;; Initialize all ELPA packages
(require 'package)
(package-initialize)

(setq package-archives '(("melpa" . "http://melpa.org/packages/")
                         ("melpa-stable" . "http://stable.melpa.org/packages/")
                         ("gnu" . "http://elpa.gnu.org/packages/")))

(let ((elapsed (float-time (time-subtract (current-time) emacs-start-time))))
  (message "Loaded packages in %.3fs" elapsed))

;; Keep customize settings in their own file
(setq custom-file "~/.emacs.d/custom.el")
(when (file-exists-p custom-file)
  (load custom-file))

(require 'cl-lib)

;; Packages that need to be installed

(defvar my/install-packages
  '(
    ;; package management
    use-package

    ;; pomodoro
    org-pomodoro

    ;; I guess this is useful
    better-defaults

    ;; themeing
    rainbow-mode color-theme-sanityinc-tomorrow smart-mode-line
    beacon rainbow-delimiters

    ;; misc
    diminish exec-path-from-shell symon

    ;; for auto-complete
    company popup

    ;; editing utilities
    smex ag ido-ubiquitous smartparens smooth-scrolling flx-ido golden-ratio
    fill-column-indicator anzu smart-tab smartparens shrink-whitespace undo-tree
    iedit smartscan ido-vertical-mode vlf imenu-anywhere projectile

    ;; infrastructure
    restclient

    ;; highlighting
    idle-highlight-mode

    ;; org-mode
    org org-bullets

    ;; buffer utils
    dired+

    ;; flycheck
    flycheck flycheck-tip flycheck-pos-tip

    ;; clojure
    clojure-mode clojure-mode-extra-font-locking cider paredit paren-face ac-cider

    ;; racket
    geiser

    ;; coffeescript
    coffee-mode

    ;; javascript
    json-mode js2-mode

    ;; ruby
    ruby-mode inf-ruby rbenv robe rspec-mode rubocop ruby-tools

    ;; emacs-lisp
    elisp-slime-nav paredit

    ;; elasticsearch
    es-mode

    ;; markup language
    markdown-mode markdown-mode+ yaml-mode web-mode

    ;; helm
    helm helm-projectile helm-ag helm-swoop helm-flx helm-flycheck

    ;; git
    magit git-gutter git-timemachine with-editor

    ;; eshell
    eshell-prompt-extras
    ))

(defvar packages-refreshed? nil)

(dolist (p my/install-packages)
  (unless (package-installed-p p)
    (unless packages-refreshed?
      (package-refresh-contents)
      (setq packages-refreshed? t))
    (unwind-protect
        (condition-case ex
            (package-install p)
          ('error (message "Failed to install package [%s], caught exception: [%s]"
                           p ex)))
      (message "Installed %s" p))))

;; Load use-package, used for loading packages everywhere else
(require 'use-package)
;; Set to t to debug package loading or nil to disable
(setq use-package-verbose t)

;; Setting up $PATH and other vars
(use-package exec-path-from-shell
  :defer t
  :init
  (progn
    (setq exec-path-from-shell-variables '("JAVA_HOME"
                                           "PATH"
                                           "WORKON_HOME"
                                           "MANPATH"
                                           "LANG"))
    (exec-path-from-shell-initialize)))

;; Basics and settings used everywhere
;; -----------------------------------

(setq user-full-name "Michalis Despotopoulos"
      user-mail-address "michaeldespoto@gmail.com")

;; prefer UTF-8 everywhere
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)

;; turn on syntax highlighting for all buffers
(global-font-lock-mode t)

;; raise maximum number of logs
(setq message-log-max 16384)

;; configure the GC
(setq gc-cons-threshold (* 100 1024 1024)) ;; 100 mb
;; Allow font-lock-mode to do background parsing
(setq jit-lock-stealth-time 1
      ;; jit-lock-stealth-load 200
      jit-lock-chunk-size 1000
      jit-lock-defer-time 0.05)

;; toggle line number limit
(setq line-number-display-limit-width 10000)

;; make gnutls a bit safer
(setq gnutls-min-prime-bits 4096)

;; delete selected region on typing
(delete-selection-mode 1)

(setq large-file-warning-threshold (* 25 1024 1024))

(transient-mark-mode 1)

(setq-default indicate-empty-lines nil)
(setq-default indicate-buffer-boundaries nil)

;; don't blink, please
(when (functionp 'blink-cursor-mode)
  (blink-cursor-mode -1))

;; don't beep and dont show startup message
(setq ring-bell-function (lambda ()))
(setq inhibit-startup-screen t
      initial-major-mode 'fundamental-mode)

;; show line and column numbers in mode-line
(line-number-mode 1)
(column-number-mode 1)

;; ignore case in file name completion
(setq read-file-name-completion-ignore-case t)

;; y or n should suffice
(defalias 'yes-or-no-p 'y-or-n-p)

;; confirm when killing only on graphical session
(when (window-system)
  (setq confirm-kill-emacs 'yes-or-no-p))

(setq line-move-visual t)

;; hide mouse while typing
(setq make-pointer-invisible t)

;; set fill-columnd to 80 chars and tab width to 2
(setq-default fill-column 80)
(setq-default default-tab-width 2)
(setq-default indent-tabs-mode nil)

;; fix some weird color escape sequences
(setq system-uses-terminfo nil)

;; resolve symlinks
(setq-default find-file-visit-truename t)

;; require newline at the end of files
(setq require-final-newline t)

;; uniquify buffers
(use-package uniquify
  :config
  (setq uniquify-buffer-name-style 'post-forward-angle-brackets))

;; search (and search/replace) using regex by default
(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-r") 'isearch-backward-regexp)
(global-set-key (kbd "M-%") 'query-replace-regexp)

;; single space ends a sentence
(setq sentence-end-double-space nil)

;; split windows
(setq split-height-threshold nil)
(setq split-width-threshold 180)

;; rescan for imenu changes
(set-default 'imenu-auto-rescan t)

;; seed random number generator
(random t)

;; switch to unified diffs
(setq diff-switches "-u")

;; turn on auto-fill mode in text buffers
(add-hook 'text-mode-hook 'turn-on-auto-fill)

(use-package diminish
  :init
  (progn
    (diminish 'auto-fill-function "")))

;; never kill the *scratch* buffer
(defadvice kill-buffer (around kill-buffer-around-advice activate)
  (let ((buffer-to-kill (ad-get-arg 0)))
    (if (equal buffer-to-kill "*scratch*")
        (bury-buffer)
      ad-do-it)))

;; version control stuff

;; automatically revert file if changed on disk
(global-auto-revert-mode 1)
;; be quiet about reverting files
(setq auto-revert-verbose nil)

;; start server if not running but only for gui
(require 'server nil t)
(use-package server
  :if window-system
  :init
  (when (not (server-running-p server-name))
    (server-start)))

;; GUI-specific
(when (window-system)
  (setenv "EMACS_GUI" "t"))

;; prettify symbols
(when (boundp 'global-prettify-symbols-mode)
  (add-hook 'emacs-lisp-mode-hook
            (lambda ()
              (push '("lambda" . ?λ) prettify-symbols-alist)))
  (add-hook 'clojure-mode-hook
            (lambda ()
              (push '("fn" . ?ƒ) prettify-symbols-alist)))
  (global-prettify-symbols-mode +1))

;; display time and load on modeline
(setq
 ;; don't display info about mail
 display-time-mail-function (lambda () nil)
 ;; update every 15 seconds (default is 60)
 display-time-interval 15)
(display-time-mode 1)

;; quit as fast as possible
(defun mu/quit-emacs-unconditionally ()
  (interactive)
  (my-quit-emacs '(4)))

(define-key special-event-map (kbd "<sigusr1>") #'my/quit-emacs-unconditionally)

(setq tls-program
      ;; Defaults:
      ;; '("gnutls-cli --insecure -p %p %h"
      ;;   "gnutls-cli --insecure -p %p %h --protocols ssl3"
      ;;   "openssl s_client -connect %h:%p -no_ssl2 -ign_eof")
      '("gnutls-cli -p %p %h"
        "openssl s_client -connect %h:%p -no_ssl2 -no_ssl3 -ign_eof"))

(use-package helm-flx
  :init (helm-flx-mode +1))

;; OS-specific settings
;; --------------------

(when (eq system-type 'darwin)
  (setq ns-use-native-fullscreen nil)
  ;; brew install coreutils
  (if (executable-find "gls")
      (progn
        (setq insert-directory-program "gls")
        (setq dired-listing-switches "-lFaGh1v --group-directories-first"))
    (setq dired-listing-switches "-ahlF"))
  (defun copy-from-osx ()
    "Handle copy/paste intelligently on osx."
    (let ((pbpaste (purecopy "/usr/bin/pbpaste")))
      (if (and (eq system-type 'darwin)
               (file-exists-p pbpaste))
          (let ((tramp-mode nil)
                (default-directory "~"))
            (shell-command-to-string pbpaste)))))

  (defun paste-to-osx (text &optional push)
    (let ((process-connection-type nil))
      (let ((proc (start-process "pbcopy" "*Messages*" "/usr/bin/pbcopy")))
        (process-send-string proc text)
        (process-send-eof proc))))
  (setq interprogram-cut-function 'paste-to-osx
        interprogram-paste-function 'copy-from-osx)

  (defun move-file-to-trash (file)
    "Use `trash' to move FILE to the system trash.
When using Homebrew, install it using \"brew install trash\"."
    (call-process (executable-find "trash")
                  nil 0 nil
                  file))

  ;; Trackpad scrolling
  (global-set-key [wheel-up] 'previous-line)
  (global-set-key [wheel-down] 'next-line))

;; Settings for temporary files
(setq savehist-additional-variables
      ;; also save my search entries
      '(search-ring regexp-search-ring)
      savehist-file "~/.emacs.d/savehist")
(savehist-mode t)
(setq-default save-place t)

;; delete auto-save files
(setq delete-auto-save-files t)
(setq backup-directory-alist
      '(("." . "~/.emacs_backups")))

;; delete old backups silently
(setq delete-old-versions t)

;; Shell settings

;; use cat for shell pager
(setenv "PAGER" "cat")

(custom-set-variables
 '(comint-scroll-to-bottom-on-input t)  ; always insert at the bottom
 '(comint-scroll-to-bottom-on-output nil) ; always add output at the bottom
 '(comint-scroll-show-maximum-output t) ; scroll to show max possible output
 ;; '(comint-completion-autolist t)     ; show completion list when ambiguous
 '(comint-input-ignoredups t)           ; no duplicates in command history
 '(comint-completion-addsuffix t)       ; insert space/slash after file completion
 '(comint-prompt-read-only nil)         ; if this is t, it breaks shell-command
 '(comint-get-old-input (lambda () ""))      ; what to run when i press enter on a
                                        ; line above the current prompt
 )

;; Tramp settings
(use-package tramp
  :defer 5
  :config
  (setq )
  ;; Turn of auto-save for tramp files
  (defun tramp-set-auto-save ()
    (auto-save-mode -1))
  (with-eval-after-load 'tramp-cache
    (setq tramp-persistency-file-name "~/.emacs.d/etc/tramp"))
  (setq tramp-default-method "ssh"
        tramp-default-user-alist '(("\\`su\\(do\\)?\\'" nil "root"))
        tramp-adb-program "adb"
        ;; use the settings in ~/.ssh/config instead of Tramp's
        tramp-use-ssh-controlmaster-options nil
        backup-enable-predicate
        (lambda (name)
          (and (normal-backup-enable-predicate name)
               (not (let ((method (file-remote-p name 'method)))
                      (when (stringp method)
                        (member method '("su" "sudo"))))))))

  (use-package tramp-sh
    :config
    (add-to-list 'tramp-remote-path "/usr/local/sbin")
    (add-to-list 'tramp-remote-path "/opt/java/current/bin")
    (add-to-list 'tramp-remote-path "~/bin")))

;; Spell check and flyspell settings
;; ---------------------------------

;; Standard location of personal dictionary
(setq ispell-personal-dictionary "~/.flydict")

;; Taken from dakrone who took it mostly from
;; http://blog.binchen.org/posts/what-s-the-best-spell-check-set-up-in-emacs.html
(when (executable-find "aspell")
  (setq ispell-program-name (executable-find "aspell"))
  (setq ispell-extra-args
        (list "--sug-mode=fast" ;; ultra/fast/normal/bad-spellers
              "--lang=en_GB" ;; TODO: can this be toggled for Greek?
              "--ignore=4")))

;; hunspell
(when (executable-find "hunspell")
  (setq ispell-program-name (executable-find "hunspell"))
  (setq ispell-extra-args '("-d en_GB")))

;; blindly copy-pasting here:
(add-to-list 'ispell-skip-region-alist '("[^\000-\377]+"))
(add-to-list 'ispell-skip-region-alist '(":\\(PROPERTIES\\|LOGBOOK\\):" . ":END:"))
(add-to-list 'ispell-skip-region-alist '("#\\+BEGIN_SRC" . "#\\+END_SRC"))
(add-to-list 'ispell-skip-region-alist '("#\\+BEGIN_EXAMPLE" . "#\\+END_EXAMPLE"))

(defun my/enable-flyspell-prog-mode ()
  (interactive)
  (flyspell-prog-mode))

(use-package flyspell
  :defer t
  :diminish ""
  :init (add-hook 'prog-mode-hook #'my/enable-flyspell-prog-mode))

;; Saveplace
;; ---------

;; navigates to where you left off
(use-package saveplace
  :defer t
  :init
  (setq-default save-place t)
  (setq save-place-file (expand-file-name ".places" user-emacs-directory)))

;; whitespace mode
(setq whitespace-style '(tabs newline space-mark
                              tab-mark newline-mark
                              face lines-tail trailing))

;; display pretty things for newlines and tabs
(setq whitespace-display-mappings
      ;; all numbers are Unicode codepoint in decimal. e.g. (insert-char 182 1)
      ;; 32 SPACE, 183 MIDDLE DOT
      '((space-mark nil)
        ;; 10 LINE FEED
        ;;(newline-mark 10 [172 10])
        (newline-mark nil)
        ;; 9 TAB, MIDDLE DOT
        (tab-mark 9 [183 9] [92 9])))

;; always turn on whitespace mode in programming buffers
(add-hook 'prog-mode-hook #'whitespace-mode)
(add-hook 'whitespace-mode-hook (lambda () (diminish 'whitespace-mode)))
;; indicate trailing empty lines in the GUI
(setq-default show-trailing-whitespace t)

;; *********************
;; Programming Languages
;; *********************

;; remove some backends form vc-mode
(setq vc-handled-backends '())

;; highlight FIXME and TODO
(defun my/add-watchwords ()
  "Highlight FIXME, TODO, and NOCOMMIT in code TODO"
  (font-lock-add-keywords
   nil '(("\\<\\(FIXME:?\\|TODO:?\\)\\>"
          1 '((:foreground "#d7a3ad") (:weight bold)) t))))

(add-hook 'prog-mode-hook #'my/add-watchwords)

;; highlight lines
(add-hook 'prog-mode-hook #'hl-line-mode)

;; hide the lighter in subword mode
(use-package subword
  :diminish subword-mode)

;; Clojure
;; -------

(defun my/setup-clojure-hook ()
  "Set up Clojure"
  (eldoc-mode 1)
  (subword-mode t)
  (paredit-mode 1)
  (global-set-key (kbd "C-c t") 'clojure-jump-between-tests-and-code))

(use-package clojure-mode
  :init
  (add-hook #'clojure-mode-hook #'my/setup-clojure-hook)
  :config
  (define-clojure-indent
    ;; Compojure routes
    (defroutes 'defun)
    (GET 2)
    (POST 2)
    (PUT 2)
    (DELETE 2)
    (HEAD 2)
    (ANY 2)
    (context 2)
    ;; Midje
    (facts 2)
    (fact 2)))

(defun my/setup-cider ()
  (interactive)
  (setq cider-history-file "~/.nrepl-history"
        cider-hide-special-buffers t
        cider-repl-history-size 10000
        cider-prefer-local-resources t
        cider-popup-stacktraces-in-repl t)
  (paredit-mode 1)
  (eldoc-mode 1))

(defun my/component-reset ()
  (interactive)
  (save-buffer)
  (set-buffer (cider-current-connection))
  (goto-char (point-max))
  (insert "(reset)")
  (cider-repl-return))

(use-package cider
  :defer 30
  :init
  (add-hook #'cider-mode-hook #'my/setup-cider)
  (add-hook #'cider-repl-mode-hook #'my/setup-cider)
  (add-hook #'cider-mode-hook #'my/setup-clojure-hook)
  (add-hook #'cider-repl-mode-hook #'my/setup-clojure-hook)
  (add-hook #'cider-mode-hook #'company-mode)
  (add-hook #'cider-repl-mode-hook #'company-mode)
  (global-set-key (kbd "C-c r") 'my/component-reset)
  :config
  (setq cider-repl-display-help-banner nil))

;; Shell
;; -----

(add-to-list 'auto-mode-alist '("\\.zsh$" . shell-script-mode))

;; Racket
;; ------

(add-hook #'scheme-mode-hook #'paredit-mode)

;; Coffeescript
;; ------------

(use-package coffee-mode
  :mode (("\\.coffee.erb\\'" . coffee-mode))
  :config
  (setq coffee-tab-width 2)
  ;; remove the "Generated by CoffeeScript" header
  (add-to-list 'coffee-args-compile "--no-header"))

;; Elisp
;; -----

(defun my/turn-on-paredit-and-eldoc ()
  (interactive)
  (paredit-mode 1)
  (eldoc-mode 1))

(add-hook 'emacs-lisp-mode-hook #'my/turn-on-paredit-and-eldoc)
(add-hook 'ielm-mode-hook #'my/turn-on-paredit-and-eldoc)

(use-package eldoc
  :diminish eldoc-mode
  :config
  (setq eldoc-idle-deplay 0.3)
  (set-face-attribute 'eldoc-highlight-function-argument nil
                      :underline t :foreground "green"
                      :weight 'bold))

;; change the faces for elisp regex grouping
(set-face-foreground 'font-lock-regexp-grouping-backslash "#ff1493")
(set-face-foreground 'font-lock-regexp-grouping-construct "#ff8c00")

(defun ielm-other-window ()
  "Run ielm on other window"
  (interactive)
  (switch-to-buffer-other-window
   (get-buffer-create "*ielm*"))
  (call-interactively 'ielm))

(define-key emacs-lisp-mode-map (kbd "C-c C-z") 'ielm-other-window)
(define-key lisp-interaction-mode-map (kbd "C-c C-z") 'ielm-other-window)

(use-package elisp-slime-nav
  :diminish elisp-slime-nav-mode
  :init (add-hook 'emacs-lisp-mode-hook #'elisp-slime-nav-mode))

;; pretty print results
(bind-key "M-:" 'pp-eval-expression)

(defun sanityinc/eval-last-sexp-or-region (prefix)
  "Eval region from BEG to END if active, otherwise the last sexp."
  (interactive "P")
  (if (and (mark) (use-region-p))
      (eval-region (min (point) (mark)) (max (point) (mark)))
    (pp-eval-last-sexp prefix)))

(bind-key "C-x C-e" 'sanityinc/eval-last-sexp-or-region emacs-lisp-mode-map)

(define-key lisp-mode-shared-map (kbd "RET") 'reindent-then-newline-and-indent)

;; Rest Client
;; -----------

(use-package restclient
  :mode ("\\.rest\\'" . restclient-mode))

;; Web Mode
;; --------

(defun my/web-mode-hook ()
  ;; Disable fill column indicator mode due to a bug.
  ;; See: https://github.com/alpaker/Fill-Column-Indicator/issues/46
  (turn-off-fci-mode)
  ;; HTML offset indentation
  (setq web-mode-markup-indent-offset 2)
  ;; CSS offset indentation
  (setq web-mode-css-indent-offset 2)
  ;; Script/code offset indentation
  (setq web-mode-code-indent-offset 2))

(use-package web-mode
  :mode (("\\.erb\\'" . web-mode)
         ("\\.html?\\'" . web-mode)
         ("\\.hbs\\'" . web-mode))
  :init (add-hook 'web-mode-hook  'my/web-mode-hook))

;; Elasticsearch

(use-package es-mode
  :mode "\\.es$")

;; Ruby
;; ----

;; (add-to-list 'auto-mode-alist '("\\.rake\\'" . ruby-mode))
;; (add-to-list 'auto-mode-alist '("Rakefile\\'" . ruby-mode))
;; (add-to-list 'auto-mode-alist '("\\.gemspec\\'" . ruby-mode))
;; (add-to-list 'auto-mode-alist '("\\.ru\\'" . ruby-mode))
;; (add-to-list 'auto-mode-alist '("Gemfile\\'" . ruby-mode))
;; (add-to-list 'auto-mode-alist '("Guardfile\\'" . ruby-mode))
;; (add-to-list 'auto-mode-alist '("Capfile\\'" . ruby-mode))
;; (add-to-list 'auto-mode-alist '("\\.cap\\'" . ruby-mode))
;; (add-to-list 'auto-mode-alist '("\\.thor\\'" . ruby-mode))
;; (add-to-list 'auto-mode-alist '("\\.rabl\\'" . ruby-mode))
;; (add-to-list 'auto-mode-alist '("Thorfile\\'" . ruby-mode))
;; (add-to-list 'auto-mode-alist '("Vagrantfile\\'" . ruby-mode))
;; (add-to-list 'auto-mode-alist '("\\.jbuilder\\'" . ruby-mode))
;; (add-to-list 'auto-mode-alist '("Podfile\\'" . ruby-mode))
;; (add-to-list 'auto-mode-alist '("\\.podspec\\'" . ruby-mode))
;; (add-to-list 'auto-mode-alist '("Puppetfile\\'" . ruby-mode))
;; (add-to-list 'auto-mode-alist '("Berksfile\\'" . ruby-mode))
;; (add-to-list 'auto-mode-alist '("Appraisals\\'" . ruby-mode))

(use-package ruby-mode
  :mode (("\\.rake\\'" . ruby-mode)
         ("Rakefile\\'" . ruby-mode)
         ("\\.gemspec\\'" . ruby-mode)
         ("\\.ru\\'" . ruby-mode)
         ("Gemfile\\'" . ruby-mode)
         ("Guardfile\\'" . ruby-mode)
         ("Capfile\\'" . ruby-mode)
         ("\\.cap\\'" . ruby-mode))
  :config
  (progn
    (inf-ruby-minor-mode +1)
    (setq ruby-insert-encoding-magic-comment nil)))

(use-package ruby-tools
  :init
  (add-hook 'ruby-mode-hook 'ruby-tools-mode)
  :diminish "")

(use-package rbenv
  :defer 25
  :init
  ;; I don't really care about the active Ruby in the modeline
  (progn
    (setq rbenv-show-active-ruby-in-modeline nil)
    (global-rbenv-mode t)))

(defadvice inf-ruby-console-auto (before activate-rbenv-for-robe activate)
  (rbenv-use-corresponding))

(use-package rspec-mode
  :defer 20
  :diminish rspec-mode
  :commands rspec-mode)

(use-package inf-ruby
  :init
  (add-hook 'after-init-hook 'inf-ruby-switch-setup))

(use-package robe
  :init
  (add-hook 'ruby-mode-hook 'robe-mode)
  :diminish ""
  :config
  (eval-after-load 'company
    '(push 'company-robe company-backends)))

;; Javascript
;; ----------

(setq-default js-indent-level 2)

(use-package js2-mode
  :mode "\\.js\\'"
  :config
  (js2-imenu-extras-setup)
  (setq-default js-auto-indent-flag nil))

;; Org-mode
;; --------

(use-package org
  :bind (("C-c l" . org-store-link)
         ("C-c a" . org-agenda)
         ("C-c b" . org-iswitchb)))

;; org-bullets
(use-package org-bullets
  :init
  (add-hook 'org-mode-hook #'org-bullets-mode))

;; *****
;; Theme
;; *****

(setq ns-use-srgb-colorspace t)

(use-package color-theme-sanityinc-tomorrow
  :init (load-theme 'sanityinc-tomorrow-eighties t))

;; Fonts
;; -----

(defun my/setup-osx-fonts ()
  (interactive)
  (when (eq system-type 'darwin)
    (set-fontset-font "fontset-default" 'symbol "Monaco")
    (set-fontset-font t 'unicode "Apple Color Emoji" nil 'prepend)
    ;; (set-default-font "Bitstream Vera Sans Mono")
    ;; (set-default-font "Fantasque Sans Mono")
    ;; (set-default-font "Fira Mono")
    ;; (set-default-font "Source Code Pro")
    (set-face-attribute 'default nil :height 140 :weight 'normal)
    (set-face-attribute 'fixed-pitch nil :height 140 :weight 'normal)

    ;; Anti-aliasing
    (setq mac-allow-anti-aliasing t)))

(when (eq system-type 'darwin)
  (add-hook 'after-init-hook #'my/setup-osx-fonts))

;; ****
;; Misc
;; ****

;; modeline
;; --------

(use-package smart-mode-line
  :init
  (progn
    (setq sml/theme 'respectful)
    (sml/setup))
  :config
  (setq sml/shorten-directory t
        sml/shorten-modes t))

;; fringe
;; ------

(defun my/set-fringe-background ()
  "Set the fringe background to the same color as the regular background."
  (interactive)
  (setq my/fringe-background-color
        (face-background 'default))
  (custom-set-faces
   `(fringe ((t (:background ,my/fringe-background-color))))))

(add-hook 'after-init-hook #'my/set-fringe-background)

;; Indicate where a buffer starts and stops
(setq-default indicate-buffer-boundaries 'right)

;; ediff
;; -----

(use-package ediff
  :config
  (progn
    (setq
     ;; Always split nicely for wide screens
     ediff-split-window-function 'split-window-horizontally)))

;; fill-column-indicator
;; ---------------------

(use-package fill-column-indicator
  :init
  (add-hook 'prog-mode-hook #'fci-mode))

;; smooth-scrolling
;; ----------------

(use-package smooth-scrolling
  :defer t
  :config
  (setq smooth-scroll-margin 3
        scroll-margin 3
        scroll-conservatively 101
        scroll-preserve-screen-position t
        auto-window-vscroll nil))

;; paredit
;; -------

(use-package paredit
  :commands paredit-mode
  :diminish "()"
  :config
  (bind-key "M-)" #'paredit-forward-slurp-sexp paredit-mode-map)
  (bind-key "C-(" #'paredit-forward-barf-sexp paredit-mode-map)
  (bind-key "C-)" #'paredit-forward-slurp-sexp paredit-mode-map)
  (bind-key ")" #'paredit-close-parenthesis paredit-mode-map)
  (bind-key "M-\"" #'my/other-window-backwards paredit-mode-map)
  (bind-key "C-M-f" #'paredit-forward paredit-mode-map)
  (bind-key "C-M-b" #'paredit-backward paredit-mode-map))

;; electric modes
;; --------------

;; Automatically instert pairs of characters
(electric-pair-mode 1)
(setq electric-pair-preserve-balance t
      electric-pair-delete-adjacent-pairs t
      electric-pair-open-newline-between-pairs nil)
(show-paren-mode 1)

;; Auto-indentation
(electric-indent-mode 1)

;; Ignore electric indentation for python and yaml
(defun electric-indent-ignore-mode (char)
  "Ignore electric indentation for python-mode"
  (if (or (equal major-mode 'python-mode)
          (equal major-mode 'yaml-mode))
      'no-indent
    nil))
(add-hook 'electric-indent-functions 'electric-indent-ignore-mode)

;; Automatic layout
(electric-layout-mode 1)

;; smartparens
;; -----------

;; TODO
(use-package smartparens
  :disabled t
  :defer 5
  :diminish smartparens-mode)

;; flycheck
;; --------

(use-package flycheck
  :defer 5
  :bind (("M-g M-n" . flycheck-next-error)
         ("M-g M-p" . flycheck-previous-error)
         ("M-g M-=" . flycheck-list-errors))
  :init (global-flycheck-mode)
  :diminish flycheck-mode
  :config
  (progn
    (setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc))
    (use-package flycheck-pos-tip
      :init (flycheck-pos-tip-mode))
    (use-package helm-flycheck
      :init (define-key flycheck-mode-map (kbd "C-c ! h") 'helm-flycheck))))

;; with-editor
;; -----------

(use-package with-editor
  :init
  (progn
    (add-hook 'shell-mode-hook 'with-editor-export-editor)
    (add-hook 'eshell-mode-hook 'with-editor-export-editor)))

;; magit
;; -----

(use-package magit
  :bind ("C-x g" . magit-status)
  :init (add-hook 'magit-mode-hook 'hl-line-mode)
  :config
  (setenv "GIT_PAGER" "")
  (if (file-exists-p  "/usr/local/bin/emacsclient")
      (setq magit-emacsclient-executable "/usr/local/bin/emacsclient")
    (setq magit-emacsclient-executable (executable-find "emacsclient"))))

;; projectile
;; ----------

(use-package projectile
  :defer 5
  :commands projectile-global-mode
  :diminish projectile-mode
  :config
  (bind-key "C-c p b" #'projectile-switch-to-buffer #'projectile-command-map)
  (bind-key "C-c p K" #'projectile-kill-buffers #'projectile-command-map)

  ;; global ignores
  (add-to-list 'projectile-globally-ignored-files ".tern-port")
  (add-to-list 'projectile-globally-ignored-files "GTAGS")
  (add-to-list 'projectile-globally-ignored-files "GPATH")
  (add-to-list 'projectile-globally-ignored-files "GRTAGS")
  (add-to-list 'projectile-globally-ignored-files "GSYMS")
  (add-to-list 'projectile-globally-ignored-files ".DS_Store")
  ;; always ignore .class files
  (add-to-list 'projectile-globally-ignored-file-suffixes ".class")
  (use-package helm-projectile
    :init
    (use-package grep) ;; required for helm-ag to work properly
    (setq projectile-completion-system 'helm)
    ;; no fuzziness for projectile-helm
    (setq helm-projectile-fuzzy-match nil)
    (helm-projectile-on))
  (projectile-global-mode))

;; git-gutter
;; ----------

(use-package git-gutter
  :defer t
  :bind (("C-x =" . git-gutter:popup-hunk)
         ("C-x P" . git-gutter:previous-hunk)
         ("C-c N" . git-gutter:next-hunk)
         ("C-x p" . git-gutter:previous-hunk)
         ("C-x n" . git-gutter:next-hunk)
         ("C-c G" . git-gutter:popup-hunk))
  :diminish ""
  :init
  (add-hook 'prog-mode-hook 'git-gutter-mode)
  (add-hook 'org-mode-hook 'git-gutter-mode))

;; anzu
;; ----

(use-package anzu
  :defer t
  :bind ("M-%" . anzu-query-replace-regexp)
  :config
  (progn
    (use-package thingatpt)
    (setq anzu-mode-lighter "")
    (set-face-attribute 'anzu-mode-line nil :foreground "yellow")))

(add-hook 'prog-mode-hook #'anzu-mode)
(add-hook 'org-mode-hook #'anzu-mode)

;; helm-swoop
;; ----------

(use-package helm-swoop
  :bind (("M-i" . helm-swoop)
         ("M-I" . helm-swoop-back-to-last-point)
         ("C-c M-i" . helm-multi-swoop))
  :config
  ;; When doing isearch, hand the word over to helm-swoop
  (define-key isearch-mode-map (kbd "M-i") 'helm-swoop-from-isearch)
  ;; From helm-swoop to helm-multi-swoop-all
  (define-key helm-swoop-map (kbd "M-i") 'helm-multi-swoop-all-from-helm-swoop)
  ;; Save buffer when helm-multi-swoop-edit complete
  (setq helm-multi-swoop-edit-save t
        ;; If this value is t, split window inside the current window
        helm-swoop-split-with-multiple-windows t
        ;; Split direcion. 'split-window-vertically or 'split-window-horizontally
        helm-swoop-split-direction 'split-window-vertically
        ;; If nil, you can slightly boost invoke speed in exchange for text color
        helm-swoop-speed-or-color nil))

;; helm
;; ----

(use-package helm-config
  :demand t
  :diminish helm-mode
  :bind
  (("C-x C-f" . helm-find-files)
   ("M-y" . helm-show-kill-ring)
   ("C-x C-i" . helm-semantic-or-imenu)
   ("M-x" . helm-M-x)
   ("C-x b" . helm-mini))
  :config
  (use-package helm-files
    :config (setq helm-ff-file-compressed-list '("gz" "bz2" "zip" "tgz" "xz" "txz")))
  (use-package helm-buffers)
  (use-package helm-mode
    :diminish helm-mode
    :init (helm-mode 1))
  (use-package helm-misc)
  (use-package helm-imenu)
  (use-package helm-semantic)
  (use-package helm-ring)
  (use-package helm-projectile
    :bind (("C-x f" . helm-projectile)
           ("C-c p f" . helm-projectile-find-file)
           ("C-c p s" . helm-projectile-switch-project)))
  (global-set-key (kbd "C-c h") 'helm-command-prefix)
  (global-unset-key (kbd "C-x c"))

  ;; Via: https://www.reddit.com/r/emacs/comments/3asbyn/new_and_very_useful_helm_feature_enter_search/
  (setq helm-echo-input-in-header-line t)
  (defun helm-hide-minibuffer-maybe ()
    (when (with-helm-buffer helm-echo-input-in-header-line)
      (let ((ov (make-overlay (point-min) (point-max) nil nil t)))
        (overlay-put ov 'window (selected-window))
        (overlay-put ov 'face (let ((bg-color (face-background 'default nil)))
                                `(:background ,bg-color :foreground ,bg-color)))
        (setq-local cursor-type nil))))
  (add-hook 'helm-minibuffer-set-up-hook 'helm-hide-minibuffer-maybe)

  (setq
   ;; truncate long lines in helm completion
   helm-truncate-lines t
   ;; do not display invisible candidates
   helm-quick-update t
   ;; open helm buffer inside current window, don't occupy whole other window
   helm-split-window-in-side-p t
   ;; move to end or beginning of source when reaching top or bottom
   ;; of source
   helm-move-to-line-cycle-in-source t
   ;; fuzzy matching
   helm-recentf-fuzzy-match t
   helm-locate-fuzzy-match nil ;; locate fuzzy is worthless
   helm-M-x-fuzzy-match t
   helm-buffers-fuzzy-matching t
   helm-semantic-fuzzy-match t
   helm-imenu-fuzzy-match t
   helm-completion-in-region-fuzzy-match t)

  (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to do persistent action
  (define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
  (define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

  (when (executable-find "curl")
    (setq helm-google-suggest-use-curl-p t))

  ;; ggrep is gnu grep on OSX
  (when (executable-find "ggrep")
    (setq helm-grep-default-command
          "ggrep -a -d skip %e -n%cH -e %p %f"
          helm-grep-default-recurse-command
          "ggrep -a -d recurse %e -n%cH -e %p %f")))

;; markdown-mode
;; -------------

(use-package markdown-mode
  :init (add-hook 'markdown-mode-hook #'whitespace-mode)
  :commands (markdown-mode gfm-mode)
  :mode (("\\README\\.md\\'" . gfm-mode)
         ("github\\.com.*\\.txt\\'" . gfm-mode)
         ("\\.md\\'"          . markdown-mode)
         ("\\.markdown\\'"    . markdown-mode)))

;; auto-completion (company)
;; -------------------------

(use-package company
  :defer t
  :diminish company-mode
  :bind ("C-." . company-complete)
  :init (add-hook #'prog-mode-hook #'company-mode)
  :config
  (progn
    (setq company-idle-delay 0.4
          ;; min prefix of 3 chars
          company-minimum-prefix-length 3
          company-selection-wrap-around t
          company-show-numbers t
          company-dabbrev-downcase nil
          company-transformers '(company-sort-by-occurrence))
    (bind-keys :map company-active-map
               ("C-n" . company-select-next)
               ("C-p" . company-select-previous)
               ("C-d" . company-show-doc-buffer)
               ("<tab>" . company-complete))))

;; smart-tab
;; ---------

(use-package smart-tab
  :defer t
  :diminish ""
  :init (global-smart-tab-mode 1)
  :config
  (progn
    (add-to-list 'smart-tab-disabled-major-modes 'mu4e-compose-mode)
    (add-to-list 'smart-tab-disabled-major-modes 'erc-mode)
    (add-to-list 'smart-tab-disabled-major-modes 'shell-mode)))

;; shrink-whitespace
;; -----------------

(use-package shrink-whitespace
  :bind (("M-SPC" . shrink-whitespace)
         ("M-S-SPC" . shrink-whitespace)))

;; undo-tree
;; ---------

(use-package undo-tree
  :init (global-undo-tree-mode t)
  :defer t
  :diminish ""
  :config
  (progn
    (define-key undo-tree-map (kbd "C-x u") 'undo-tree-visualize)
    (define-key undo-tree-map (kbd "C-/") 'undo-tree-undo)))

;; paren-face
;; ----------

(use-package paren-face
  :init (global-paren-face-mode))

;; ido-mode
;; --------

(use-package ido
  :config
  (use-package ido-ubiquitous
    :init (ido-ubiquitous-mode 1))
  (use-package flx-ido
    :init (flx-ido-mode 1)
    :config (setq ido-use-faces nil))
  (use-package ido-vertical-mode
    :disabled t
    :init (ido-vertical-mode t))
  (setq ido-use-virtual-buffers nil
        ;; this settings causes weird TRAMP connections, don't set it!
        ;; ido-enable-tramp-completion nil
        ido-enable-flex-matching t
        ido-auto-merge-work-directories-length nil
        ido-create-new-buffer 'always
        ido-use-filename-at-point 'guess
        ido-max-prospects 10))

;; smex
;; ----

;; TODO maybe try helm someday?
(use-package smex
  :disabled t
  :bind (("M-x" . smex)
         ("M-X" . smex-major-mode-commands)))

;; iedit
;; -----

;; Use it to edit every instance of a word in the buffer.
(use-package iedit
  :bind ("C-;" . iedit-mode))

;; imenu-anywhere
;; --------------

(use-package imenu-anywhere
  :disabled t
  :bind (("C-c i" . imenu-anywhere)))

;; beacon
;; ------

;; Flash cursor whenever you adjust position.
(use-package beacon
  :diminish beacon-mode
  :init (beacon-mode 1))

;; smartscan
;; ---------

;; Jump between the same variable in multiple places.
(use-package smartscan
  :init (add-hook #'prog-mode-hook #'smartscan-mode)
  :config
  (bind-key "M-'" #'other-window smartscan-map))

;; symon
;; -----

;; Show system monitor when Emacs is inactive
(use-package symon
  :if window-system
  :disabled t
  :init
  (setq symon-refresh-rate 2
        symon-delay 5)
  (symon-mode 1)
  :config
  (setq symon-sparkline-type 'bounded))

;; vlf
;; ---

;; View large files
(use-package vlf-setup)

;; idle-highlight-mode
;; -------------------

;; Hightlight idle things. Only in certain modes.
(use-package idle-hightlight-mode
  :init
  (add-hook 'java-mode-hook #'idle-highlight-mode)
  (add-hook 'emacs-lisp-mode-hook #'idle-highlight-mode)
  (add-hook 'clojure-lisp-mode-hook #'idle-highlight-mode))

;; rainbow-delimiters-mode
;; -----------------------

;; Use different colors per set of parenthesis. Only in lisps.
(use-package rainbow-delimiters
  :init
  (add-hook #'emacs-lisp-mode-hook #'rainbow-delimiters-mode)
  (add-hook #'clojure-mode-hook #'rainbow-delimiters-mode)
  (add-hook #'scheme-mode-hook #'rainbow-delimiters-mode))

;; *******************
;; Extra Functionality
;; *******************

(defadvice server-visit-files (before parse-numbers-in-lines (files proc &optional nowait) activate)
  "Open file with emacsclient with cursors positioned on requested line.
Most of console-based utilities prints filename in format
'filename:linenumber'.  So you may wish to open filename in that format.
Just call:

  emacsclient filename:linenumber

and file 'filename' will be opened and cursor set on line 'linenumber'"
  (ad-set-arg 0
              (mapcar (lambda (fn)
                        (let ((name (car fn)))
                          (if (string-match "^\\(.*?\\):\\([0-9]+\\)\\(?::\\([0-9]+\\)\\)?$" name)
                              (cons
                               (match-string 1 name)
                               (cons (string-to-number (match-string 2 name))
                                     (string-to-number (or (match-string 3 name) ""))))
                            fn))) files)))

;; Better C-a
;; See http://emacsredux.com/blog/2013/05/22/smarter-navigation-to-the-beginning-of-a-line/
;; Code borrowed from Prelude

(defun smart-move-beginning-of-line (arg)
  "Move point back to indentation of beginning of line.

Move point to the first non-whitespace character on this line.
If point is already there, move to the beginning of the line.
Effectively toggle between the first non-whitespace character and
the beginning of the line.

If ARG is not nil or 1, move forward ARG - 1 lines first.  If
point reaches the beginning or end of the buffer, stop there."
  (interactive "^p")
  (setq arg (or arg 1))

  ;; Move lines first
  (when (/= arg 1)
    (let ((line-move-visual nil))
      (forward-line (1- arg))))

  (let ((orig-point (point)))
    (back-to-indentation)
    (when (= orig-point (point))
      (move-beginning-of-line 1))))

(global-set-key [remap move-beginning-of-line]
                'smart-move-beginning-of-line)

;; Cleaning a buffer
(defun untabify-buffer ()
  (interactive)
  (untabify (point-min) (point-max)))

(defun indent-buffer ()
  (interactive)
  (indent-region (point-min) (point-max)))

(defvar bad-cleanup-modes '(python-mode yaml-mode)
  "List of modes where `cleanup-buffer' should not be used")

(defun cleanup-buffer ()
  "Perform a bunch of operations on the whitespace content of a buffer. If the
buffer is one of the `bad-cleanup-modes' then only whitespace is stripped."
  (interactive)
  (unless (member major-mode bad-cleanup-modes)
    (progn
      (indent-buffer)
      (untabify-buffer)))
  (whitespace-cleanup))

;; Perform general cleanup.
(global-set-key (kbd "C-c n") #'cleanup-buffer)

;; Clean whitespace after saving
(add-hook 'before-save-hook 'whitespace-cleanup)

;; ************
;; Key Bindings
;; ************

;; Join on killing lines
(defun kill-and-join-forward (&optional arg)
  "If at end of line, join with following; otherwise kill line.
Deletes whitespace at join."
  (interactive "P")
  (if (and (eolp) (not (bolp)))
      (delete-indentation t)
    (kill-line arg)))

(global-set-key (kbd "C-k") 'kill-and-join-forward)

;; Join line to next line
(global-set-key (kbd "M-j")
                (lambda ()
                  (interactive)
                  (join-line -1)))

;; Completion that uses many different methods to find options.
(global-set-key (kbd "M-/") 'hippie-expand)

;; Font size
(define-key global-map (kbd "C-+") 'text-scale-increase)
(define-key global-map (kbd "C--") 'text-scale-decrease)

;; Window switching
(defun my/other-window-backwards ()
  (interactive)
  (other-window -1))

(global-set-key (kbd "M-'") 'other-window)
(global-set-key (kbd "M-\"") 'my/other-window-backwards)
(global-set-key (kbd "H-'") 'other-window)
(global-set-key [C-tab] 'other-window)
(global-set-key [C-S-tab] 'my/other-window-backwards)

;; Next two functions are borrowed from emacs prelude.

(defun my/smart-open-line-above ()
  "Insert an empty line above the current line.
Position the cursor at it's beginning, according to the current mode."
  (interactive)
  (move-beginning-of-line nil)
  (newline-and-indent)
  (forward-line -1)
  (indent-according-to-mode))

(defun my/smart-open-line (arg)
  "Insert an empty line after the current line.
Position the cursor at its beginning, according to the current mode.

With a prefix ARG open line above the current line."
  (interactive "P")
  (if arg
      (my/prelude-smart-open-line-above)
    (progn
      (move-end-of-line nil)
      (newline-and-indent))))

(global-set-key (kbd "s-o") 'my/smart-open-line-above)
(global-set-key (kbd "M-o") 'my/smart-open-line)

;; **************
;; Finalize Setup
;; **************

(setq debug-on-error nil)
(setq debug-on-quit nil)

;; Message how long it took to load everything (minus packages)
(let ((elapsed (float-time (time-subtract (current-time)
                                          emacs-start-time))))
  (message "Loading settings...done (%.3fs)" elapsed))
(put 'narrow-to-region 'disabled nil)
