;;; mk-visual.el --- Control appearance -*- lexical-binding: t; -*-
;;;
;;; Copyright © 2015 Mark Karpov <markkarpov@opmbx.org>
;;;
;;; This file is not part of GNU Emacs.
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

;;; Commentary:

;;; When run under X system, set color theme and switch to full screen mode.

;;; Code:

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

(provide 'mk-visual)

;;; mk-visual.el ends here
