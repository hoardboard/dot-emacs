;;; .emacs --- Emacs configuration file (GNU Emacs 24.4.1)
;;;
;;; Commentary:
;;;
;;; In order to use spell-checking you need to install the following
;;; packages (OS level):
;;; * aspell{,-en,-ru,-fr}
;;;
;;; For Haskell development install (with cabal):
;;; * happy
;;; * alex
;;; * ghc-mod
;;;
;;; Copyright (c) 2015 Mark Karpov
;;;
;;; This program is free software: you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by the
;;; Free Software Foundation, either version 3 of the License, or (at your
;;; option) any later version.
;;;
;;; This program is distributed in the hope that it will be useful, but
;;; WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
;;; Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License along
;;; with this program. If not, see <http://www.gnu.org/licenses/>.

;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                        ;;
;;                             Various Stuff                              ;;
;;                                                                        ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'cl)
(require 'package)
(require 'bytecomp)

(add-to-list
 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))

(package-initialize)

(defvar vital-packages
  '(ace-window            ; switching between windows
    buffer-move           ; move buffers easily
    cider                 ; for Clojure development
    fill-column-indicator ; paints vertical line on the right
    flycheck              ; checking code on the fly
    flycheck-haskell      ; for cabal sandboxes, etc.
    ghc                   ; improves Haskell REPL experience
    haskell-mode          ; for Haskell development
    ido-hacks             ; various ido goodies
    ido-ubiquitous        ; use ido in more places
    magit                 ; Emacs mode for git
    markdown-mode         ; for markdown editing
    prolog                ; for Prolog development
    rainbow-delimiters    ; use it for Lisps
    smooth-scroll         ; pretty scrolling experience
    solarized-theme)      ; my favorite color theme
  "List of packages that must be installed.")

;; Install all the packages automatically if they are not installed.

(unless package-archive-contents
  (package-refresh-contents))

(defun delete-window-by-name (name)
  "Delete all windows that display buffer with name NAME."
  (when (get-buffer name)
    (dolist (window (get-buffer-window-list name))
      (delete-window window))))

(dolist (package vital-packages)
  (unless (package-installed-p package)
    (package-install package)))

(require 'smooth-scroll)

;; Let's load SLIME with Slime Helper, if there is `slime-helper.el' file,
;; we byte-compile it and entire SLIME, and next time we will be able to
;; load SLIME faster. If there is more recent version of `slime-helper.el'
;; available, we should recompile it (and SLIME).

(defvar slime-helper-el  (expand-file-name "~/quicklisp/slime-helper.el")
  "Path to SLIME helper that comes with Quicklisp.")
(defvar slime-helper-elc (byte-compile-dest-file slime-helper-el)
  "Path to byte-compiled SLIME helper.")

(when (and (file-exists-p slime-helper-el)
           (or (not (file-exists-p slime-helper-elc))
               (file-newer-than-file-p slime-helper-el
                                       slime-helper-elc)))
  (byte-compile-file slime-helper-el t)
  (shell-command (concat "cd \"" slime-path
                         "\" ; make compile contrib-compile")))

(when (and (file-exists-p slime-helper-elc)
           (not (find 'slime features)))
  (load-file slime-helper-elc))

;; Clearing after compilation...

(delete-window-by-name "*Compile-Log*")
(delete-window-by-name "*Shell Command Output*")

(require 'server)

(unless (server-running-p)
  (server-start))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                        ;;
;;                               Variables                                ;;
;;                                                                        ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq-default
 auto-fill-mode                    1       ; wrapping lines beyond limit
 auto-save-default                 nil     ; don't ever create autosaves
 browse-url-browser-function       'browse-url-generic
 browse-url-generic-program        "icecat"
 calendar-week-start-day           1       ; Monday
 cider-docview-fill-column         76      ; some Cider's variables
 cider-repl-display-in-current-window t    ; ^
 cider-repl-result-prefix          ";; => "; ^
 cider-show-error-buffer           nil     ; ^
 cider-stacktrace-fill-column      76      ; ^
 column-number-mode                t       ; display column number
 delete-by-moving-to-trash         t       ; in dired mode
 dired-auto-revert-buffer          t       ; automatically revert buffer
 dired-dwim-target                 t       ; guess target directory
 dired-keep-marker-copy            nil     ; don't mark copied files
 dired-listing-switches            "-GAlh --group-directories-first"
 dired-recursive-copies            'always ; don't ask me, just do it
 dired-recursive-deletes           'always ; ^
 display-time-24hr-format          t       ; 24 hours format for time
 display-time-default-load-average nil     ; don't clutter my status line
 echo-keystrokes                   0.1     ; show keystrokes asap
 erc-nick                          "mrkkrp"
 fci-rule-column                   80      ; position of rule column
 fill-column                       76      ; set fill column
 gc-cons-threshold                 10240000 ; garbage collection every 10 Mb
 gnus-permanently-visible-groups   ""      ; always show all groups
 haskell-ask-also-kill-buffers     nil     ; don't ask
 haskell-process-show-debug-tips   nil     ; don't show anything
 ido-auto-merge-work-directories-length -1 ; disable it
 ido-create-new-buffer             'always
 ido-decorations                   '("" "" "·" "…" "" "" " no match" " matched"
                                     " not readable" " too big" " confirm")
 ido-enable-flex-matching          t
 ido-everywhere                    t
 indent-tabs-mode                  nil     ; only spaces
 inferior-lisp-program             "sbcl"
 inhibit-startup-screen            t       ; remove welcome screen
 initial-scratch-message           ";; Μὴ μοῦ τοὺς κύκλους τάραττε\n\n"
 kill-read-only-ok                 t       ; don't rise errors, it's OK
 magit-last-seen-setup-instructions "1.4.0"
 Man-width                         fill-column ; fill column for man pages
 large-file-warning-threshold      10240000 ; warn when opening >10 Mb file
 major-mode                        'text-mode ; default mode is text mode
 make-backup-files                 nil     ; don't create backups
 minibuffer-eldef-shorten-default  t       ; shorten defaults in minibuffer
 nrepl-buffer-name-show-port       nil
 org-agenda-files                  '("~/todo.org")
 org-catch-invisible-edits         'show   ; make point visible
 require-final-newline             t
 resize-mini-windows               t       ; grow and shrink
 ring-bell-function                'ignore ; no annoying alarms
 scroll-margin                     3
 scroll-step                       1
 send-mail-function                'smtpmail-send-it
 smtpmail-smtp-server              "smtp.openmailbox.org"
 smtpmail-smtp-service             587
 suggest-key-bindings              nil
 tab-width                         4       ; tab width for text-mode
 user-full-name                    "Mark Karpov"
 user-mail-address                 "markkarpov@opmbx.org"
 safe-local-variable-values        '((Syntax  . ANSI-Common-Lisp)
                                     (Base    . 10)
                                     (Package . CL-USER)
                                     (Syntax  . COMMON-LISP)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                        ;;
;;                                 Modes                                  ;;
;;                                                                        ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(blink-cursor-mode                 0) ; my cursor doesn't blink, man
(delete-selection-mode             1) ; delete selection mode enabled
(display-time-mode                 1) ; displaying time
(global-auto-revert-mode           1) ; revert buffers automatically
(global-subword-mode               1) ; move through camel case, etc.
(ido-mode                          1) ; ido for switch-buffer and find-file
(ido-ubiquitous-mode               1) ; use ido everywhere
(menu-bar-mode                    -1) ; hide menu bar
(minibuffer-electric-default-mode  1) ; electric minibuffer
(scroll-bar-mode                  -1) ; disable scroll bar
(show-paren-mode                   1) ; highlight parenthesis
(smooth-scroll-mode                t) ; smooth scroll
(tool-bar-mode                    -1) ; hide tool bar
(which-function-mode               1) ; displays current function

;; open .pl files as Prolog files, not Perl files
(add-to-list 'auto-mode-alist '("\\.pl\\'" . prolog-mode))

(dolist (buffer '("^\*Backtrace\*"
                  "^\*Compile-Log\*"
                  "^\*.+Completions\*"
                  "^\*Flycheck error messages\*"
                  "^\*Help\*"
                  "^\*Ibuffer\*"
                  "^\*Messages\*"
                  "^\*inferior-lisp\*"
                  "^\*scratch\*"
                  "^\*slime-compilation\*"
                  "^\*slime-description\*"
                  "^\*slime-events\*"))
  (add-to-list 'ido-ignore-buffers buffer))

(eval-after-load 'which-func
  '(setq which-func-format  (list (cadr which-func-format))
         which-func-unknown "⊥"))

(put 'dired-do-copy    'ido      nil) ; use ido there
(put 'dired-do-rename  'ido      nil) ; ^
(put 'downcase-region  'disabled nil) ; don't ever doubt my power
(put 'erase-buffer     'disabled nil) ; ^
(put 'upcase-region    'disabled nil) ; ^

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                        ;;
;;                                Bindings                                ;;
;;                                                                        ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun point-mid ()
  "Return middle position of point in the buffer."
  (/ (- (point-max) (point-min)) 2))

(defun transpose-line-down ()
  "Move current line and cursor down."
  (interactive)
  (let ((col (current-column)))
    (forward-line    1)
    (transpose-lines 1)
    (forward-line   -1)
    (move-to-column col)))

(defun transpose-line-up ()
  "Move current line and cursor up."
  (interactive)
  (let ((col (current-column)))
    (transpose-lines 1)
    (forward-line   -2)
    (move-to-column col)))

(defun duplicate-line ()
  "Copy current line and yank its copy under the current
line. Position of point shifts one line down."
  (interactive)
  (let ((col (current-column)))
    (kill-ring-save
     (progn
       (move-beginning-of-line 1)
       (point))
     (progn
       (forward-line 1)
       (point)))
    (yank)
    (forward-line -1)
    (move-to-column col)))

(defun show-date (&optional stamp)
  "Show current date in the minibuffer. If STAMP is not NIL,
insert date into currently active buffer."
  (interactive)
  (funcall (if stamp #'insert #'message)
           (format-time-string "%A, %d %B %Y")))

(defvar basic-buffers
  '("^\*scratch\*"
    "^\*Messages\*"
    "^irc\.freenode\.net:6667"
    "^#.+")
  "These are regexps to match names of buffers that I don't want
to purge with PURGE-BUFFERS command.")

(defun purge-buffers ()
  "Kill all buffer except those that have names listed in
BASIC-BUFFERS."
  (interactive)
  (let ((redundant-buffers
         (remove-if (lambda (name)
                      (some (lambda (regexp)
                              (string-match-p regexp name))
                            basic-buffers))
                    (mapcar #'buffer-name (buffer-list)))))
    (mapc (lambda (name)
            (kill-buffer
             (if (get-buffer name)
                 name
               (subseq name 0 (or (position ?< name :from-end t)
                                  (length name))))))
          redundant-buffers)
    (switch-to-buffer "*scratch*")
    (delete-other-windows)))

(defun search-online ()
  "Search Internet with DuckDuckGo."
  (interactive)
  (browse-url
   (concat "https://duckduckgo.com/html/?k1=-1&q="
           (url-hexify-string
            (if mark-active
                (buffer-substring (region-beginning)
                                  (region-end))
              (read-string "DuckDuckGo: "))))))

(defun upgrade-all-packages ()
  "Upgrade all packages automatically."
  (interactive)
  (package-refresh-contents)
  (let (upgrades)
    (cl-flet ((get-version (name where)
                (package-desc-version (cadr (assq name where)))))
      (dolist (package (mapcar #'car package-alist))
        (when (version-list-< (get-version package package-alist)
                              (get-version package package-archive-contents))
          (push (cadr (assq package package-archive-contents))
                upgrades))))
    (if (null upgrades)
        (message "All packages are up to date.")
      (when (yes-or-no-p
             (message "Upgrade %d package%s (%s)? "
                      (length upgrades)
                      (if (= (length upgrades) 1) "" "s")
                      (mapconcat #'package-desc-full-name upgrades ", ")))
        (dolist (package-desc upgrades)
          (let ((old-package (cadr (assq (package-desc-name package-desc)
                                         package-alist))))
            (package-install package-desc)
            (package-delete  old-package)))
        (delete-window-by-name "*Compile-Log*")))))

(defun compile-init-file ()
  "Byte compile init file."
  (interactive)
  (let ((compiled (byte-compile-dest-file user-init-file)))
    (if (or (not (file-exists-p compiled))
            (file-newer-than-file-p user-init-file
                                    compiled))
        (progn
          (byte-compile-file user-init-file)
          (delete-window-by-name "*Compile-Log*"))
      (message "Byte compiled init file exists and it's up to date."))))

(defun visit-file (filename)
  "Visit specified file FILENAME. If the file does not exist,
print a message about the fact."
  (let ((filename (expand-file-name filename)))
    (if (file-exists-p filename)
        (find-file filename)
      (message (concat filename " does not exist.")))))

(defun tim (input-method dictionary)
  "Switch between given input method (and aspell dictionary) and
normal input method."
  (if (eq current-input-method input-method)
      (progn
        (deactivate-input-method)
        (ispell-change-dictionary "default"))
    (set-input-method input-method)
    (ispell-change-dictionary dictionary)))

(defun slime-in-package ()
  "Load specified package and switch to it."
  (interactive)
  (let ((pkg-name (read-string "Package name: ")))
    (slime-repl-eval-string
     (concat "(progn (asdf:load-system :"
             pkg-name
             ")(cl:in-package :"
             pkg-name
             "))"))))

(defmacro cmd (fnc &rest args)
  "Interactively invoke function FNC with arguments ARGS."
  `(lambda (&rest rest)
     (interactive)
     (apply,fnc ,@args rest)))

(defun gkbd (key fnc)
  "A shortcut for `global-set-key' that uses `kbd'."
  (global-set-key (kbd key) fnc))

(defmacro lkbd (file keymap key def)
  "Little helper to write mode-specific key definitions prettier."
  `(eval-after-load ',file
     '(define-key
        (symbol-value (intern (concat (symbol-name ',keymap) "-mode-map")))
        (kbd ,key) ,def)))

(gkbd "C-c r"      #'revert-buffer)
(gkbd "C-c p"      #'purge-buffers)
(gkbd "C-c s"      #'search-online)
(gkbd "C-c g"      #'upgrade-all-packages)
(gkbd "C-c b"      #'compile-init-file)
(gkbd "C-c e"      (cmd #'visit-file user-init-file))
(gkbd "C-c t"      (cmd #'visit-file (car org-agenda-files)))
(gkbd "C-c a"      #'org-agenda-list)
(gkbd "C-c i"      #'flyspell-correct-word-before-point)
(gkbd "C-x o"      #'ace-window)
(gkbd "C-'"        #'ace-window)
(gkbd "M-p"        #'transpose-line-up)
(gkbd "M-n"        #'transpose-line-down)
(gkbd "<f2>"       #'save-buffer)
(gkbd "<f5>"       #'find-file)
(gkbd "<f6>"       #'find-file-other-window)
(gkbd "<f7>"       (cmd #'tim "french-keyboard"  "fr"))
(gkbd "<f8>"       (cmd #'tim "russian-computer" "ru"))
(gkbd "<f9>"       (cmd #'kill-buffer nil))
(gkbd "<f10>"      #'delete-other-windows)
(gkbd "<f11>"      #'switch-to-buffer)
(gkbd "<f12>"      #'save-buffers-kill-terminal)
(gkbd "<escape>"   #'delete-window)
(gkbd "<C-return>" #'duplicate-line)
(gkbd "<S-up>"     #'buf-move-up)
(gkbd "<S-down>"   #'buf-move-down)
(gkbd "<S-left>"   #'buf-move-left)
(gkbd "<S-right>"  #'buf-move-right)
(gkbd "<menu>"     nil)
(gkbd "<menu> ,"   (cmd #'push-mark))
(gkbd "<menu> ."   (cmd #'goto-char (mark)))
(gkbd "<menu> /"   (cmd #'goto-char (point-mid)))
(gkbd "<menu> <"   (cmd #'goto-char (point-min)))
(gkbd "<menu> >"   (cmd #'goto-char (point-max)))
(gkbd "<menu> a p" #'apropos)
(gkbd "<menu> a r" #'align-regexp)
(gkbd "<menu> c a" #'calc)
(gkbd "<menu> c i" #'cider-jack-in)
(gkbd "<menu> c l" #'calendar)
(gkbd "<menu> c s" #'set-buffer-file-coding-system)
(gkbd "<menu> d a" (cmd #'show-date))
(gkbd "<menu> d i" #'diff)
(gkbd "<menu> e r" #'erc)
(gkbd "<menu> g d" #'gdb)
(gkbd "<menu> g l" #'goto-line)
(gkbd "<menu> g n" #'gnus)
(gkbd "<menu> h r" #'split-window-below)
(gkbd "<menu> k r" #'kill-rectangle)
(gkbd "<menu> l b" #'list-buffers)
(gkbd "<menu> l i" #'slime)
(gkbd "<menu> l p" #'list-packages)
(gkbd "<menu> m a" #'magit-status)
(gkbd "<menu> m n" #'man)
(gkbd "<menu> q r" #'query-replace)
(gkbd "<menu> r n" #'rectangle-number-lines)
(gkbd "<menu> s c" #'run-scheme)
(gkbd "<menu> s h" #'shell)
(gkbd "<menu> s l" #'sort-lines)
(gkbd "<menu> s r" #'string-rectangle)
(gkbd "<menu> s s" (cmd #'switch-to-buffer "*scratch*"))
(gkbd "<menu> s t" (cmd #'show-date t))
(gkbd "<menu> t e" #'tetris)
(gkbd "<menu> v r" #'split-window-right)
(gkbd "<menu> y r" #'yank-rectangle)

(lkbd cc-mode       c                "C-c C-l" #'compile)
(lkbd dired         dired            "b"       #'dired-up-directory)
(lkbd dired         dired            "z"       #'wdired-change-to-wdired-mode)
(lkbd haskell    haskell-interactive "C-c h"   #'haskell-hoogle)
(lkbd haskell-cabal haskell-cabal    "M-n"     #'transpose-line-down)
(lkbd haskell-cabal haskell-cabal    "M-p"     #'transpose-line-up)
(lkbd haskell-mode  haskell          "C-c h"   #'haskell-hoogle)
(lkbd lisp-mode     emacs-lisp       "C-c h"   #'slime-hyperspec-lookup)
(lkbd lisp-mode     lisp             "C-c h"   #'slime-hyperspec-lookup)
(lkbd org           org              "C-'"     #'ace-window)
(lkbd slime         slime            "M-n"     #'transpose-line-down)
(lkbd slime         slime            "M-p"     #'transpose-line-up)
(lkbd slime         slime-repl       "C-c i"   #'slime-in-package)
(lkbd slime         slime-repl       "C-c r"   #'slime-restart-inferior-lisp)
(lkbd markdown-mode markdown         "M-n"     #'transpose-line-down)
(lkbd markdown-mode markdown         "M-p"     #'transpose-line-up)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                        ;;
;;                                Aliases                                 ;;
;;                                                                        ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defalias 'list-buffers #'ibuffer)
(defalias 'yes-or-no-p  #'y-or-n-p)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                        ;;
;;                             Hooks & Advice                             ;;
;;                                                                        ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar hidden-minor-modes
  '(abbrev-mode
    auto-fill-function
    eldoc-mode
    flycheck-mode
    flyspell-mode
    haskell-doc-mode
    haskell-indent-mode
    inf-haskell-mode
    interactive-haskell-mode
    ispell-minor-mode
    magit-auto-revert-mode
    slime-mode
    smooth-scroll-mode
    subword-mode
    superword-mode)
  "Collection of minor modes that should not appear in the mode
line.")

(defvar major-mode-alias
  '((c-mode                   . "C")
    (cider-repl-mode          . "ic")
    (clojure-mode             . "c")
    (diff-mode                . "Δ")
    (dired-mode               . "δ")
    (emacs-lisp-mode          . "ε")
    (haskell-interactive-mode . "iH")
    (haskell-mode             . "H")
    (lisp-interaction-mode    . "iε")
    (lisp-mode                . "λ")
    (markdown-mode            . "M")
    (prolog-inferior-mode     . "iP")
    (prolog-mode              . "P")
    (sh-mode                  . "sh")
    (slime-repl-mode          . "iλ")
    (wdired-mode              . "wδ"))
  "Shorter alias for some major modes.")

(defun fix-mode-representation ()
  "Put empty strings for minor modes in HIDDEN-MINOR-MODES into
MINOR-MODE-ALIST, effectively evicting them from the status
line. Substitute names of some major modes using values from
MAJOR-MODE-NAMES."
  (dolist (x hidden-minor-modes)
    (let ((trg (cdr (assoc x minor-mode-alist))))
      (when trg
        (setcar trg ""))))
  (let ((mode-alias (cdr (assoc major-mode major-mode-alias))))
    (when mode-alias
      (setq mode-name mode-alias))))

(defun prepare-prog-mode ()
  "This function enables some minor modes when user works on some
source."
  (auto-fill-mode 1)
  (setq-local comment-auto-fill-only-comments t)
  (flyspell-prog-mode)
  (flycheck-mode))

(defun haskell-mode-helper ()
  "Some auxiliary things for Haskell support."
  (electric-indent-local-mode 0)
  (interactive-haskell-mode)
  (turn-on-haskell-doc-mode)
  (turn-on-haskell-indent))

(defun ido-key-bindings ()
  "Helper to define some non-standard key bindings in ido mode."
  (define-key ido-completion-map (kbd "C-b") #'ido-prev-match)
  (define-key ido-completion-map (kbd "C-f") #'ido-next-match))

(add-hook 'after-change-major-mode-hook #'fci-mode)
(add-hook 'after-change-major-mode-hook #'fix-mode-representation)
(add-hook 'before-save-hook             #'delete-trailing-whitespace)
(add-hook 'clojure-mode-hook            #'rainbow-delimiters-mode)
(add-hook 'dired-mode-hook              #'hl-line-mode)
(add-hook 'emacs-lisp-mode-hook         #'rainbow-delimiters-mode)
(add-hook 'emacs-lisp-mode-hook         #'eldoc-mode)
(add-hook 'erc-mode-hook                #'flyspell-mode)
(add-hook 'flycheck-mode-hook           #'flycheck-haskell-setup)
(add-hook 'gnus-group-mode-hook         #'hl-line-mode)
(add-hook 'gnus-summary-mode-hook       #'hl-line-mode)
(add-hook 'haskell-mode-hook            #'haskell-mode-helper)
(add-hook 'ibuffer-mode-hook            #'hl-line-mode)
(add-hook 'ido-setup-hook               #'ido-key-bindings)
(add-hook 'lisp-interaction-mode-hook   #'eldoc-mode)
(add-hook 'prog-mode-hook               #'prepare-prog-mode)
(add-hook 'scheme-mode-hook             #'rainbow-delimiters-mode)
(add-hook 'slime-mode-hook              #'rainbow-delimiters-mode)
(add-hook 'text-mode-hook               #'auto-fill-mode)
(add-hook 'text-mode-hook               #'flyspell-mode)

(defmacro ira (&rest args)
  "Make lambda that always interactively returns list of this
macro's arguments ignoring any arguments passed to it."
  `(lambda (&rest rest)
     (interactive)
     ',args))

(advice-add 'compile         :filter-args (ira "cd .. ; make -k"))
(advice-add 'haskell-session-new-assume-from-cabal :override (lambda ()))
(advice-add 'org-agenda-todo :after       #'org-save-all-org-buffers)
(advice-add 'revert-buffer   :filter-args (ira nil t))
(advice-add 'save-buffers-kill-terminal :filter-args (ira t))
(advice-add 'wdired-change-to-dired-mode :after #'fix-mode-representation)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                        ;;
;;                        Only Under Window System                        ;;
;;                                                                        ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(when window-system
  (set-face-attribute 'default
                      nil
                      :family "Ubuntu Mono"
                      :height 120)
  (set-face-attribute 'variable-pitch
                      nil
                      :family "Ubuntu Mono")
  (load-theme 'solarized-dark t)
  (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
                         '(2 "_NET_WM_STATE_FULLSCREEN" 0)))
