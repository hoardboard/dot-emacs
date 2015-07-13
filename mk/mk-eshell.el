;;; mk-eshell.el --- Emacs shell settings -*- lexical-binding: t; -*-
;;
;; Copyright © 2015 Mark Karpov <markkarpov@openmailbox.org>
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

;; Emacs shell related customization.

;;; Code:

(require 'mk-utils)

(add-to-list 'major-mode-alias '(eshell-mode . "εsh"))
(add-to-list 'kill-or-bury-alive-must-die-list 'eshell-mode)

(defun eshell-other-window (fnc &optional arg)
  "Open Emacs shell (via FNC) in other window.
ARG is argument to pass to Emacs shell."
  (let ((eshell-buffer (funcall fnc arg)))
    (switch-to-prev-buffer)
    (switch-to-buffer-other-window eshell-buffer)))

(add-hook 'eshell-mode-hook #'smartparens-mode)

(advice-add 'eshell :around #'eshell-other-window)

(provide 'mk-eshell)

;;; mk-eshell.el ends here
