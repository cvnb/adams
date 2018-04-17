;;
;;  adams  -  Remote system administration tools
;;
;;  Copyright 2013,2014 Thomas de Grivel <thomas@lowh.net>
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

(defun run-as-root (&rest command)
  (apply #'run
         (unless (equal "root" (get-probed (current-host) :user))
           "sudo ")
         command))

;;  Host operations

(defmethod op-hostname ((host host) (os os-unix) &key hostname)
  (run-as-root "hostname -s " (sh-quote hostname)))

;;  Group

(defmethod op-update-group ((group group) (os os-unix) &key ensure gid)
  (run-as-root
   (join-str " "
             (ecase ensure
               ((:absent)  "groupdel")
               ((:present) "groupadd")
               ((nil)      "groupmod"))
             (when gid `("-g" ,(sh-quote gid)))
             (sh-quote (resource-id group)))))

;;  User

(defmethod op-update-user ((user user) (os os-unix) &key ensure uid gid
                                                      realname home shell
                                                      login-class
                                                      groups)
  (run-as-root
   (join-str " "
             (ecase ensure
               ((:absent)  "userdel")
               ((:present) "useradd")
               ((nil)      "usermod"))
             (when realname `("-c" ,(sh-quote realname)))
             (when home `("-d" ,(sh-quote home)))
             (when gid `("-g" ,(sh-quote gid)))
             (when login-class `("-L" ,(sh-quote login-class)))
             (when groups `("-S" ,(join-str "," (mapcar #'sh-quote groups))))
             (when shell `("-s" ,(sh-quote shell)))
             (when uid `("-u" ,(sh-quote uid)))
             (sh-quote (resource-id user)))))

;;  VNode

(defmethod op-chown ((res vnode) (os os-unix) &key uid gid owner group
                                                &allow-other-keys)
  (when (stringp owner)
    (setq owner (resource 'user owner)))
  (when (stringp group)
    (setq group (resource 'group group)))
  (when (and uid owner)
    (assert (= uid (get-probed owner :uid))))
  (when (and gid group)
    (assert (= gid (get-probed group :gid))))
  (let ((u (or (when owner (resource-id owner))
               uid))
        (g (or (when group (resource-id group))
               gid)))
    (run "chown " u (when g `(":" ,g)) " " (resource-id res))))

(defmethod op-chmod ((res vnode) (os os-unix) &key mode
                                                &allow-other-keys)
  (run "chmod " (octal (mode-permissions mode)) " " (sh-quote (resource-id res))))