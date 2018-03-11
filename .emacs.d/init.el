;; ==== For more configuration reference, check ================================
;; ==== http://book.emacs-china.org ============================================

;; *===========================================================================*
;; *    Internal Settings                                                      *
;; *===========================================================================*

;; ---- Hide tool-bar ----------------------------------------------------------
(tool-bar-mode -1)

;; ---- Show line numbers ------------------------------------------------------
(setq linum-format "%4d  ")
(setq-default left-fringe-width 6)
(global-linum-mode 1)

;; ---- Hide menu bar (you can stil call it out by typing [F10]) ---------------
(menu-bar-mode -1)

;; ---- Define function of opening configuration file --------------------------
(defun open-init-file()
  (interactive)
  (find-file "~/.emacs.d/init.el"))

;; ---- Bind [F2] to the function of opening configuration file ----------------
(global-set-key (kbd "<f2>") 'open-init-file)

;; ---- Stop editor from auto-backup -------------------------------------------
(setq make-backup-files nil)

;; ---- Disable auto-save ------------------------------------------------------
(setq auto-save-default nil)

;; ---- Delete selection on input after selecting a range ----------------------
(delete-selection-mode 1)

;; ---- Highlight current line -------------------------------------------------
(global-hl-line-mode 1)
(set-face-background 'hl-line "#000000")

;; ---- Change indentation width -----------------------------------------------
(setq-default c-basic-offset 4
              tab-width 4
              indent-tabs-mode nil
              standard-indent 4)
(c-set-offset 'substatement-open 0)
(setq tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 76 80))

;; ---- Turn on folding --------------------------------------------------------
(add-hook 'prog-mode-hook #'hs-minor-mode)
(global-set-key (kbd "C-t") 'hs-toggle-hiding)

;; ---- Setup key-bindings for moving lines up & down --------------------------
(defun move-line-up ()
  "Move current line upwards."
  (interactive)
  (transpose-lines 1)
  (forward-line -2)
  (indent-according-to-mode))
(defun move-line-down ()
  "Move current line downwards."
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1)
  (indent-according-to-mode))
(global-set-key (kbd "M-<up>") 'move-line-up)
(global-set-key (kbd "M-<down>") 'move-line-down)

;; ---- Setup key-bindings for duplicating lines -------------------------------
(defun duplicate-line-up ()
  "Duplicate the line upwards."
  (interactive)
  (move-beginning-of-line 1)
  (forward-line 1)
  (let ((beg (point)))
    (forward-line -1)
    (kill-ring-save beg (point)))
  (yank)
  (indent-according-to-mode)
  (forward-line -1))
(defun duplicate-line-down ()
  "Duplicate the line downwards."
  (interactive)
  (move-beginning-of-line 1)
  (let ((beg (point)))
    (forward-line 1)
    (kill-ring-save beg (point)))
  (yank)
  (indent-according-to-mode)
  (forward-line -1))
(global-set-key (kbd "M-S-<up>") 'duplicate-line-up)
(global-set-key (kbd "M-S-<down>") 'duplicate-line-down)

;; *===========================================================================*
;; *    Package Initialization : Manage Package List Here                      *
;; *                                                                           *
;; *    Packages require a minimum version of Emacs-24.3                       *
;; *===========================================================================*

;; ---- Call for package setting -----------------------------------------------
(require 'package)

;; ---- Add MELPA as a package source ------------------------------------------
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (url (concat (if no-ssl "http" "https") "://melpa.org/packages/")))
  (add-to-list 'package-archives (cons "melpa" url) t))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))

;; ---- Load package settings --------------------------------------------------
(package-initialize)

;; ---- Set up package list for auto installation ------------------------------
(require 'cl)    ;; Call for common lisp extension
(defvar my/packages '(
		      ;; ---- Auto-completion --------
              company                     ;; Auto complete
		      ;; ---- Editor Improvment ------
              multiple-cursors            ;; Multiple cursors
              neotree                     ;; File tree
              smex                        ;; Mini-buffer improvement
              tabbar                      ;; Tabs of buffers
              yasnippet                   ;; Snippets
		      ;; ---- Major Modes ------------
              cuda-mode
              js2-mode
              markdown-mode
              ;; ---- Minor Modes ------------
              ;; fill-column-indicator    ;; Known conflict with company
		      ;; ---- Themes -----------------
              monokai-theme
              powerline                   ;; (dependent for smart-mode-line)
              smart-mode-line             ;; Mode line beautify
              hlinum                      ;; Highlight current line number
              ) "Default packages")
(setq package-selected-packages my/packages)
(defun my/packages-installed-p()
  (loop for pkg in my/packages
    when (not (package-installed-p pkg)) do (return nil)
    finally (return t)))
(unless (my/packages-installed-p)
  (message "%s" "Updating packages...")
  (package-refresh-contents)
  (dolist (pkg my/packages)
    (when (not (package-installed-p pkg))
      (package-install pkg))))

;; *===========================================================================*
;; *    Manual settings for packages must appear under this line               *
;; *                                                                           *
;; *    Make sure package in UPPERCASE is installed before using               *
;; *                                                                           *
;; *    Packages should be arranged in alphabetical order unless depending     *
;; *===========================================================================*

;; ---- [ COMPANY ] Turn on auto complete --------------------------------------
(global-company-mode 1)

;; ---- [ HLINUM ] -------------------------------------------------------------
(require 'hlinum)
(hlinum-activate)
(set-face-attribute
 'linum-highlight-face nil
 :foreground "brightwhite"
 :weight 'bold
 :background "#000000")

;; ---- [ MONOKAI-THEME ] Turn on the theme ------------------------------------
(load-theme 'monokai 1)

;; ---- [ MULTIPLE-CURSOR ] Enable multi-cursor and bind keys ------------------
(require 'multiple-cursors)
  ;; Add multiple cursors on each line selected
(global-set-key (kbd "C-c C-c") 'mc/edit-lines)
;; Add cursor to matched records
(global-set-key (kbd "C-d") 'mc/mark-next-like-this)

;; ---- KNOWN-ISSUE: ADD THIS LINE AFTER COMPANY. ------------------------------
(define-key company-mode-map (kbd "C-d") 'mc/mark-next-like-this)

(global-set-key (kbd "C-M-d") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-d") 'mc/mark-all-like-this)
  ;; Keep multicursor state on pressing [Enter]. Cancel by C-g.
(define-key mc/keymap (kbd "<return>") nil)

;; ---- [ NEOTREE ] ------------------------------------------------------------
(require 'neotree)
(global-set-key (kbd "<f8>") 'neotree-toggle)

;; ---- [ POWERLINE ] Turn on powerline for emacs ------------------------------
;;(require 'powerline)
;; In order to make powerline seperators available user patched fonts for
;; powerline on github 
;;(powerline-default-theme)

;; ---- [ AIRLINE-THEMES ] (dependent: POWERLINE) Enable powerline themes ------
;;(require 'airline-themes)
;;(load-theme 'airline-kolor t)

;;(setq powerline-utf-8-separator-left       #xe0b0
;;      powerline-utf-8-separator-right      #xe0b2
;;      airline-utf-glyph-separator-left     #xe0b0
;;      airline-utf-glyph-separator-right    #xe0b2
;;      airline-utf-glyph-subseparator-left  #xe0b1
;;      airline-utf-glyph-subseparator-right #xe0b3
;;      airline-utf-glyph-branch             #xe0a0
;;      airline-utf-glyph-readonly           #xe0a2
;;      airline-utf-glyph-linenumber         #xe0a1)

;; ---- [ SMART-MODE-LINE ] ----------------------------------------------------
(setq column-number-mode 1)
(setq size-indication-mode 1)
(setq sml/no-confirm-load-theme t)
(setq sml/modified-char "\u00a4")
(setq sml/pre-minor-modes-separator "  \u3009")
(setq sml/pre-modes-separator "  \u300b ")
(setq sml/size-indication-format "  %I  \u3009")
(setq sml/col-number-format "%2c  \u300b")
(sml/setup)
(set-face-attribute
 'sml/col-number nil
 :foreground "brightwhite")
(set-face-attribute
 'sml/modes nil
 :foreground "brightwhite")
(set-face-attribute
 'sml/minor-modes nil
 :foreground "white")
(set-face-attribute
 'sml/position-percentage nil
 :foreground "#A6E22E")
(set-face-attribute
 'sml/prefix nil
 :foreground "#AE81FF")

;; ---- [ SMEX ] Turn on smex on load ------------------------------------------
(require 'smex)
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
  ;; below is the original command extending
(global-set-key (kbd "C-c M-x") 'execute-extended-command)

;; ---- [ TABBAR ] -------------------------------------------------------------
(require 'tabbar)
(tabbar-mode t)
(global-set-key (kbd "M-<left>") 'tabbar-backward-tab)
(global-set-key (kbd "M-<right>") 'tabbar-forward-tab)
(global-set-key (kbd "C-<left>") 'tabbar-backward-group)
(global-set-key (kbd "C-<right>") 'tabbar-forward-group)

(set-face-attribute
 'tabbar-default nil
 :background "gray20"
 :foreground "gray20"
 :box '(:line-width 1 :color "gray20" :style nil))
(set-face-attribute
 'tabbar-unselected nil
 :background "gray30"
 :foreground "white"
 :box '(:line-width 5 :color "gray30" :style nil))
(set-face-attribute
 'tabbar-selected nil
 :background "gray75"
 :foreground "black"
 :box '(:line-width 5 :color "gray75" :style nil))
(set-face-attribute
 'tabbar-highlight nil
 :background "white"
 :foreground "black"
 :underline nil
 :box '(:line-width 5 :color "white" :style nil))
(set-face-attribute
 'tabbar-button nil
 :box '(:line-width 1 :color "gray20" :style nil))
(set-face-attribute
 'tabbar-separator nil
 :background "gray20"
 :height 0.6)

;; ---- [YASNIPPET] Turn on yasnippet on load ----------------------------------
(require 'yasnippet)
(yas-global-mode 1)

;; ---- [ AUTO-GENERATED : AVOID MODIFYING ] -----------------------------------
;; For smart-mode-line
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" default))))
