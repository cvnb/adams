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

(in-package :cl-user)

(require :adams)

(in-package :adams-user)

;; TEST

(setf (debug-p :shell) t)
(setf (debug-p :sb-shell) nil)

(assert (string= (machine-instance) (first (run "hostname"))))

(adams:clear-resources)

(resource 'host "ams.kmx.io"
          :user "root"
          :hostname "ams"
          :packages '("emacs" "git" "rsync" "sbcl")
          (resource 'group "dx"
                    :gid 19256)
          (resource 'user "dx"
                    :uid 19256
                    :gid 19256
                    :home "/home/dx"))

(with-host "ams.kmx.io"
  (sync *host*))

(resource 'host "vu.kmx.io"
          :user "root"
          :hostname "vu"
          :packages '("emacs" "git" "rsync" "sbcl")
          (resource 'group "dx"
                    :gid 19256)
          (resource 'user "dx"
                    :uid 19256
                    :gid 19256
                    :home "/home/dx"))

(with-host "vu.kmx.io"
  (sync *host*))
