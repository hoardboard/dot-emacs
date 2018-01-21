;;; mk-shakespeare.el --- Shakespearean templates -*- lexical-binding: t; -*-
;;
;; Copyright © 2015–2018 Mark Karpov <markkarpov92@gmail.com>
;;
;; This file is not part of GNU Emacs.
;;
;; This program is free software: you can redistribute it and/or modify it
;; under the terms of the GNU General Public License as published by the
;; Free Software Foundation, either version 3 of the License, or (at your
;; option) any later version.
;;
;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
;; Public License for more details.
;;
;; You should have received a copy of the GNU General Public License along
;; with this program. If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Shakespearean templates are used in Haskell web development with
;; Yesod.  Here are some tweaks.

;;; Code:

(eval-when-compile
  (require 'smartparens))

(sp-with-modes '(shakespeare-hamlet-mode)
  (sp-local-pair "<" ">"))

(provide 'mk-shakespeare)

;;; mk-shakespeare.el ends here
