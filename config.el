;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Hardcode default frame size for Doom Emacs
(add-to-list 'default-frame-alist '(width . 240))   ;; width in characters
(add-to-list 'default-frame-alist '(height . 80))   ;; height in lines
(add-to-list 'default-frame-alist '(top . 50))      ;; optional: Y position in pixels
(add-to-list 'default-frame-alist '(left . 100))    ;; optional: X position in pixels

;; macOS glass appearance, available in the patched Emacs Plus build.
(when (and (eq system-type 'darwin)
           (bound-and-true-p ns-emacs-plus-version))
  (dolist (parameter
           '((alpha-background . 0.78)
             (ns-background-blur . 28)
             (ns-alpha-elements ns-alpha-all)
             (undecorated-round . t)
             (internal-border-width . 14)
             (drag-internal-border . t)
             (drag-with-header-line . t)
             (drag-with-tab-line . t)))
    (add-to-list 'default-frame-alist parameter))

  (defun vl/apply-liquid-glass (&optional frame)
    "Apply the macOS glass effect to FRAME."
    (with-selected-frame (or frame (selected-frame))
      (set-frame-parameter nil 'alpha-background 0.50)
      (set-frame-parameter nil 'ns-background-blur 28)
      (set-frame-parameter nil 'ns-alpha-elements '(ns-alpha-all))))

  (add-hook 'after-make-frame-functions #'vl/apply-liquid-glass)
  (add-hook 'window-setup-hook #'vl/apply-liquid-glass)

  (when (display-graphic-p)
    (vl/apply-liquid-glass)))

;; Org → LaTeX → PDF config
(after! ox-latex
  ;; Use xelatex via latexmk by default
  (setq org-latex-compiler "xelatex"
        org-latex-pdf-process
        '("latexmk -xelatex -interaction=nonstopmode -output-directory=%o %f")))

;; LaTeX previews in org buffers (inline equations)
(setq org-preview-latex-default-process 'dvisvgm)

;; Start an Emacs server so emacsclient can be used (e.g., from MailMate)
(server-start)

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-gruvbox)
;; (load-theme 'base16-charcoal-dark t)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")
;; Where your org files live
(setq org-default-notes-file (expand-file-name "inbox.org" org-directory))
(setq org-agenda-files (list org-directory))

;; Dictionary
(setq ispell-program-name "aspell")
(setq ispell-dictionary "en_GB")

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;
(add-hook 'text-mode-hook (lambda () (flyspell-mode -1)))
(add-hook 'org-mode-hook  (lambda () (flyspell-mode -1)))
(add-hook 'prog-mode-hook (lambda () (flyspell-mode -1)))

(after! flyspell
  (flyspell-lazy-mode -1)
  (remove-hook 'text-mode-hook #'flyspell-mode)
  (remove-hook 'prog-mode-hook #'flyspell-prog-mode))

;; Visual line stuff
(map! :n "j" #'evil-next-visual-line
      :n "k" #'evil-previous-visual-line)

;; Capture template
(after! org
  (setq org-capture-templates
        '(("t" "Todo" entry
           (file "~/org/inbox.org")
           "* TODO %?\n  %U\n\n")

          ("n" "Note" entry
           (file "~/org/inbox.org")
           "* %?\n  %U\n  %a\n\n"))))

;; Task labels
(after! org
  (setq org-todo-keywords
        '(
          ;; (sequence
          ;;  "[ ](T)"
          ;;  "[-](S)"
          ;;  "[?](W)"
          ;;  "|"
          ;;  "[X](D)")

          ;; (sequence
          ;;  "|"
          ;;  "OKAY(O)"
          ;;  "YES(Y)"
          ;;  "NO(N)")

          (sequence
           "TODO(t)"
           "NEXT(n)"
           ;; "IDEA(i)"
           "HOLD(h)"
           "WAIT(w)"
           "FUTURE(f)"
           "|"
           "DONE(d)"
           "KILL(k)"))))

(after! org
  (setq org-todo-keyword-faces
        `(
          ;; Main workflow
          ("TODO"   . (:foreground ,(doom-color 'green)  :weight bold))
          ("NEXT"   . (:foreground ,(doom-color 'orange)  :weight bold))
          ("WAIT"   . (:foreground ,(doom-color 'magenta) :weight bold))
          ("HOLD"   . (:foreground ,(doom-color 'magenta)   :weight semi-bold))
          ("IDEA"   . (:foreground ,(doom-color 'green)  :weight semi-bold))
          ("FUTURE" . (:foreground ,(doom-color 'green)   :slant italic))

          ;; Closed states
          ("DONE"   . (:foreground ,(doom-color 'base6)   :weight bold))
          ("KILL"   . (:foreground ,(doom-color 'red)     :strike-through t))

          ;; Checkbox-style sequence
          ("[ ]"    . (:foreground ,(doom-color 'base6)))
          ("[-]"    . (:foreground ,(doom-color 'orange)))
          ("[?]"    . (:foreground ,(doom-color 'magenta)))
          ("[X]"    . (:foreground ,(doom-color 'green)   :weight bold))

          ;; Decisions
          ("OKAY"   . (:foreground ,(doom-color 'blue)    :weight bold))
          ("YES"    . (:foreground ,(doom-color 'green)   :weight bold))
          ("NO"     . (:foreground ,(doom-color 'red)     :weight bold)))))

;; Show stuff in agenda
(after! org-agenda
  (setq org-agenda-prefix-format
        '((agenda . " %i %-16:c %-12:t ")
          (todo   . " %i %-16:c ")
          (tags   . " %i %-16:c ")
          (search . " %i %-16:c "))))

;; Close fix
(setq confirm-kill-emacs nil)

(after! evil
  (evil-ex-define-cmd "q" #'delete-frame)
  (evil-ex-define-cmd "wq" #'evil-save-and-close)
  (evil-ex-define-cmd "qa" #'kill-emacs))

;; Agenda show scheduled task in global TODO
(after! org
  (setq org-agenda-todo-ignore-scheduled t
        org-agenda-todo-ignore-deadlines t))

;; Agenda views
(after! org-agenda
  ;; Define custom agenda commands
  (setq org-agenda-custom-commands
        (append org-agenda-custom-commands
                '(("d." "Agenda: Daily"
                   agenda ""
                   ((org-agenda-span 'day)))

                  ("ds" "Agenda: Standard (10 days)"
                   agenda ""
                   ((org-agenda-span 10)))

                  ("dw" "Agenda: Weekly"
                   agenda ""
                   ((org-agenda-span 'week)))

                  ("df" "Agenda: Fortnight (14 days)"
                   agenda ""
                   ((org-agenda-span 14)))

                  ("dm" "Agenda: Monthly"
                   agenda ""
                   ((org-agenda-span 'month)))

                  ("dy" "Agenda: Yearly"
                   agenda ""
                   ((org-agenda-span 'year)))))))

;; Bind them under SPC d (global leader)
(map! :leader
      :prefix ("d" . "agenda")
      :desc "Agenda (day)"        "." (lambda () (interactive) (org-agenda nil "d."))
      :desc "Agenda (standard)"   "s" (lambda () (interactive) (org-agenda nil "ds"))
      :desc "Agenda (week)"       "w" (lambda () (interactive) (org-agenda nil "dw"))
      :desc "Agenda (fortnight)"  "f" (lambda () (interactive) (org-agenda nil "df"))
      :desc "Agenda (month)"      "m" (lambda () (interactive) (org-agenda nil "dm"))
      :desc "Agenda (year)"       "y" (lambda () (interactive) (org-agenda nil "dy")))

;; ;; Blank lines before heading
(after! org
  (setq org-blank-before-new-entry
        '((heading . nil)
          (plain-list-item . nil))
        org-insert-heading-respect-content t))

;; Russian quotes
(map!
 :i "M-[" #'insert-left-guillemet
 :i "M-]" #'insert-right-guillemet)

(defun insert-left-guillemet ()
  (interactive)
  (insert "«"))

(defun insert-right-guillemet ()
  (interactive)
  (insert "»"))

;; Line numbers in agenda
(after! org-agenda
  (add-hook 'org-agenda-mode-hook (lambda ()
                                    (display-line-numbers-mode -1))))

;; Rust
(after! rustic
  (setq rustic-format-on-save t
        rustic-lsp-client 'eglot))

(setenv "PATH" (concat (expand-file-name "~/.cargo/bin") ":" (getenv "PATH")))
(add-to-list 'exec-path (expand-file-name "~/.cargo/bin"))


;; Never show line numbers in Treemacs or terminal buffers
(add-hook 'treemacs-mode-hook
          (lambda ()
            (display-line-numbers-mode -1)))

(add-hook 'vterm-mode-hook
          (lambda ()
            (display-line-numbers-mode -1)))

(add-hook 'term-mode-hook
          (lambda ()
            (display-line-numbers-mode -1)))

(add-hook 'eshell-mode-hook
          (lambda ()
            (display-line-numbers-mode -1)))

;; Inlay hints disable
(after! eglot
  (add-to-list 'eglot-ignored-server-capabilities :inlayHintProvider)
  ;; (setq eglot-code-action-indications '(margin))
  ;; (add-hook 'eglot-managed-mode-hook
  ;;           (lambda ()
  ;;             (setq-local eldoc-documentation-functions nil)))
  (set-face-attribute 'eglot-semantic-struct nil
                      :inherit 'font-lock-type-face)
  (set-face-attribute 'eglot-semantic-defaultLibrary nil
                      :inherit 'font-lock-type-face))

;; (after! flycheck
;;   (remove-hook 'flycheck-mode-hook #'flycheck-popup-tip-mode))

;; Relative line numbers
(setq display-line-numbers-type 'relative)

;; Tag placement stuff
(setq org-tags-column 'auto)
(setq org-agenda-tags-column 'auto)

;; VTerm not Evil
(after! vterm
  (add-hook 'vterm-mode-hook #'evil-emacs-state))

;; Evil escape
(after! evil-escape
  (setq evil-escape-key-sequence "kj"
        evil-escape-delay 0.2))

;; Email Stuff
(setq user-full-name "Владимир Ларин"
      user-mail-address "larinvladimirvladimirovich@gmail.com")

(after! smtpmail
  (setq send-mail-function #'smtpmail-send-it
        message-send-mail-function #'smtpmail-send-it

        smtpmail-smtp-server "smtp.gmail.com"
        smtpmail-smtp-service 587
        smtpmail-stream-type 'starttls))

;; Syntax highlighting
(custom-set-faces!
  ;; Function usages/calls
  '(eglot-semantic-function
    :foreground "#ebdbb2"
    :weight normal
    :underline nil)

  ;; Variable usages
  '(eglot-semantic-variable
    :foreground "#d5c4a1"
    :weight normal
    :underline nil)

  ;; All declarations: functions, variables, types, etc.
  ;; Do NOT set foreground here if you want functions and variables
  ;; to keep different colors.
  '(eglot-semantic-declaration
    :weight bold
    :foreground "#83a598"
    ;; :underline t
    )

  ;; Fallbacks from normal font-lock
  '(font-lock-function-name-face
    :foreground "#ebdbb2"
    :weight normal)

  '(font-lock-variable-name-face
    :foreground "#d5c4a1"
    :weight normal))

;; (setq doom-font (font-spec :family "Monaspace Argon NF" :size 14))

;; Vivid highlights that remain transparent through ns-alpha-all.
(custom-set-faces!
  ;; Visual selection: electric blue.
  '(region
    :background "#83a598"
    :foreground "#ffffff"
    :extend t)

  '(show-paren-match
    :foreground "#b8bb26"
    :background "#504945"
    :weight ultra-bold
    :box (:line-width -1 :color "#b8bb26"))

  '(show-paren-mismatch
    :foreground "#fb4934"
    :background "#504945"
    :weight ultra-bold
    :box (:line-width -1 :color "#fb4934"))
  
  ;; Current / search result: vivid yellow.
  '(isearch
    :background "#ffd60a"
    :foreground "#ffffff"
    :weight bold
    :box (:line-width -1 :color "#ffd60a"))

  '(evil-ex-search
    :background "#ffd60a"
    :foreground "#ffffff"
    :weight bold
    :box (:line-width -1 :color "#ffd60a"))

  ;; Other / search results: vivid orange.
  '(lazy-highlight
    :background "#ff6b00"
    :foreground "#ffffff"
    :weight bold)

  '(evil-ex-lazy-highlight
    :background "#ff6b00"
    :foreground "#ffffff"
    :weight bold)

  ;; Occur, query-replace and other generic matches: purple.
  '(match
    :background "#bf5af2"
    :foreground "#ffffff"
    :weight bold))
