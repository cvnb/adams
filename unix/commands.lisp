;;
;;  adams - system administrator written in Common Lisp
;;
;;  Copyright 2013,2014,2018 Thomas de Grivel <thoxdg@gmail.com>
;;
;;  Permission to use, copy, modify, and distribute this software for any
;;  purpose with or without fee is hereby granted, provided that the above
;;  copyright notice and this permission notice appear in all copies.
;;
;;  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
;;  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
;;  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
;;  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
;;  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
;;  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
;;  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
;;

(in-package :adams)

(in-re-readtable)

(defun uname ()
  (re-bind #~"^(\S+) (\S+) (\S+) (.+) (\S+)$"
      (os-name node-name os-release os-version machine)
    (run-1 "uname -a")))

(defun grep_ (pattern &rest files)
  (join-str " " "grep" (sh-quote pattern) (mapcar #'sh-quote files)))

(defun grep (pattern &rest files)
  (run (apply #'grep_ pattern files)))

(defun egrep_ (pattern &rest files)
  (join-str " " "egrep" (sh-quote pattern) (mapcar #'sh-quote files)))

(defun egrep (pattern &rest files)
  (run (apply #'egrep_ pattern files)))

(defun stat_ (options &rest files)
  (join-str " " "stat" options (mapcar #'sh-quote files)))

(defun stat (options &rest files)
  (run (apply #'stat_ options files)))

(defun ls_ (options &rest files)
  (join-str " " "ls" options (mapcar #'sh-quote files)))

(defun ls (options &rest files)
  (run (apply #'ls_ options files)))

(defun sudo_ (&rest command)
  (join-str " " "sudo" command))

(defun sudo (&rest command)
  (run (apply #'sudo_ command)))
