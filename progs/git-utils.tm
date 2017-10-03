<TeXmacs|1.99.5>

<style|<tuple|generic|literate>>

<\body>
  <doc-data|<doc-title|Utils for Git>|<doc-author|<author-data|<author-name|Darcy
  SHEN>>>>

  <section|Module>

  <\scm-chunk|git-utils.scm|false|true>
    (texmacs-module (git-utils))
  </scm-chunk>

  <section|Constants>

  <\scm-chunk|git-utils.scm|true|true>
    (define callgit "git")

    (define NR_LOG_OPTION " -1000 ")

    \;

    (define gitroot "invalid")
  </scm-chunk>

  <section|Subroutines>

  <\scm-chunk|git-utils.scm|true|true>
    (define (delete-tail-newline a-str)

    \ \ (if (string-ends? a-str "\\n")

    \ \ \ \ \ \ (delete-tail-newline (string-drop-right a-str 1))

    \ \ \ \ \ \ a-str))
  </scm-chunk>

  <subsection|buffer>

  <\scm-chunk|git-utils.scm|true|true>
    (tm-define (git-root dir)

    \ \ (let* ((git-dir (url-append dir ".git"))

    \ \ \ \ \ \ \ \ \ (pdir (url-expand (url-append dir ".."))))

    \ \ \ \ (cond ((url-directory? git-dir)

    \ \ \ \ \ \ \ \ \ \ \ (string-replace (url-\<gtr\>string dir) "\\\\"
    "/"))

    \ \ \ \ \ \ \ \ \ \ ((== pdir dir) "invalid")

    \ \ \ \ \ \ \ \ \ \ (else (git-root pdir)))))

    \;

    (tm-define (git-versioned? name)

    \ \ (when (not (buffer-tmfs? name))

    \ \ \ \ (set! gitroot

    \ \ \ \ \ \ \ \ \ \ (git-root (if (url-directory? name)

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ name

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (url-head name))))

    \ \ \ \ (set! callgit

    \ \ \ \ \ \ \ \ \ \ (string-append "git --work-tree=" gitroot

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ " --git-dir=" gitroot
    "/.git")))

    \ \ (url-directory? gitroot))

    \;

    (tm-define (buffer-status name)

    \ \ (let* ((name-s (url-\<gtr\>string name))

    \ \ \ \ \ \ \ \ \ (cmd (string-append callgit " status --porcelain "
    name-s))

    \ \ \ \ \ \ \ \ \ (ret (eval-system cmd)))

    \ \ \ \ (cond ((\<gtr\> (string-length ret) 3) (string-take ret 2))

    \ \ \ \ \ \ \ \ \ \ ((file-exists? name-s) " \ ")

    \ \ \ \ \ \ \ \ \ \ (else ""))))

    \;

    (tm-define (buffer-to-unadd? name)

    \ \ (with ret (buffer-status name)

    \ \ \ \ \ \ \ \ (or (== ret "A ")

    \ \ \ \ \ \ \ \ \ \ \ \ (== ret "M ")

    \ \ \ \ \ \ \ \ \ \ \ \ (== ret "MM")

    \ \ \ \ \ \ \ \ \ \ \ \ (== ret "AM"))))\ 

    \;

    (tm-define (buffer-to-add? name)

    \ \ (with ret (buffer-status name)

    \ \ \ \ \ \ \ \ (or (== ret "??")

    \ \ \ \ \ \ \ \ \ \ \ \ (== ret " M")

    \ \ \ \ \ \ \ \ \ \ \ \ (== ret "MM")

    \ \ \ \ \ \ \ \ \ \ \ \ (== ret "AM"))))

    \;

    (tm-define (buffer-histed? name)

    \ \ (with ret (buffer-status name)

    \ \ \ \ \ \ \ \ (or (== ret "M ")

    \ \ \ \ \ \ \ \ \ \ \ \ (== ret "MM")

    \ \ \ \ \ \ \ \ \ \ \ \ (== ret " M")

    \ \ \ \ \ \ \ \ \ \ \ \ (== ret " \ "))))

    \;

    (tm-define (buffer-has-diff? name)

    \ \ (with ret (buffer-status name)

    \ \ \ \ \ \ \ \ (or (== ret "M ")

    \ \ \ \ \ \ \ \ \ \ \ \ (== ret "MM")

    \ \ \ \ \ \ \ \ \ \ \ \ (== ret " M"))))

    \;

    (tm-define (buffer-tmfs? name)

    \ \ (string-starts? (url-\<gtr\>string name)

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ "tmfs"))
  </scm-chunk>

  <section|Git Operations>

  <subsection|git add>

  <shell|git add $filename>

  <todo|The concat of the cmd should be a subroutine and should not directly
  call string-append>

  <\scm-chunk|git-utils.scm|true|true>
    (tm-define (git-add name)

    \ \ (let* ((name-s (url-\<gtr\>string name))

    \ \ \ \ \ \ \ \ \ (cmd (string-append callgit " add " name-s))

    \ \ \ \ \ \ \ \ \ (ret (eval-system cmd)))

    \ \ \ \ (set-message cmd "The file is added")))
  </scm-chunk>

  <subsection|git unadd>

  <shell|git reset HEAD $filename>

  <\scm-chunk|git-utils.scm|true|true>
    (tm-define (git-unadd name)

    \ \ (display name)

    \ \ (let* ((name-s (url-\<gtr\>string name))

    \ \ \ \ \ \ \ \ \ (cmd (string-append callgit " reset HEAD " name-s))

    \ \ \ \ \ \ \ \ \ (ret (eval-system cmd)))

    \ \ \ \ (set-message cmd "The file is unadded.")

    \ \ \ \ (display cmd)))
  </scm-chunk>

  <subsection|git log>

  <\scm-chunk|git-utils.scm|true|true>
    (tm-define (buffer-log name)

    \ \ (let* ((name1 (string-replace (url-\<gtr\>string name) "\\\\" "/"))

    \ \ \ \ \ \ \ \ \ (sub (string-append gitroot "/"))

    \ \ \ \ \ \ \ \ \ (name-s (string-replace name1 sub ""))

    \ \ \ \ \ \ \ \ \ (cmd (string-append

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ callgit " log --pretty=%ai%n%an%n%s%n%H%n"

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ NR_LOG_OPTION

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ name1))

    \ \ \ \ \ \ \ \ \ (ret1 (eval-system cmd))

    \ \ \ \ \ \ \ \ \ (ret2 (string-decompose ret1 "\\n\\n")))

    \ \ \ \ (define (string-\<gtr\>commit-file str)

    \ \ \ \ \ \ (string-\<gtr\>commit str name-s))

    \ \ \ \ (and (\<gtr\> (length ret2) 0)

    \ \ \ \ \ \ \ \ \ (string-null? (cAr ret2))

    \ \ \ \ \ \ \ \ \ (map string-\<gtr\>commit-file (cDr ret2)))))

    \;

    (tm-define (git-log)

    \ \ (let* ((cmd (string-append

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ callgit

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ " log --pretty=%ai%n%an%n%s%n%H%n"

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ NR_LOG_OPTION))

    \ \ \ \ \ \ \ \ \ (ret1 (eval-system cmd))

    \ \ \ \ \ \ \ \ \ (ret2 (string-decompose ret1 "\\n\\n")))

    \ \ \ \ (define (string-\<gtr\>commit-diff str)

    \ \ \ \ \ \ (string-\<gtr\>commit str ""))

    \ \ \ \ (and (\<gtr\> (length ret2) 0)

    \ \ \ \ \ \ \ \ \ (string-null? (cAr ret2))

    \ \ \ \ \ \ \ \ \ (map string-\<gtr\>commit-diff (cDr ret2)))))
  </scm-chunk>

  <subsection|git diff>

  <\scm-chunk|git-utils.scm|true|true>
    (tm-define (git-compare-with-current name)

    \ \ (let* ((name-s (url-\<gtr\>string name))

    \ \ \ \ \ \ \ \ \ (file-r (cAr (string-split name-s #\\\|)))

    \ \ \ \ \ \ \ \ \ (file (string-append gitroot "/" file-r)))

    \ \ \ \ (switch-to-buffer (string-\<gtr\>url file))

    \ \ \ \ (compare-with-older name)))

    \;

    (tm-define (git-compare-with-parent name)

    \ \ (let* ((name-s (tmfs-cdr (tmfs-cdr (url-\<gtr\>tmfs-string name))))

    \ \ \ \ \ \ \ \ \ (hash (first (string-split name-s #\\\|)))

    \ \ \ \ \ \ \ \ \ (file (second (string-split name-s #\\\|)))

    \ \ \ \ \ \ \ \ \ (file-buffer-s (tmfs-url-commit (git-commit-file-parent
    file hash)

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ "\|"
    file))

    \ \ \ \ \ \ \ \ \ (parent (string-\<gtr\>url file-buffer-s)))

    \ \ \ \ (if (== name parent)

    \ \ \ \ \ \ \ \ ;; FIXME: should prompt a dialog

    \ \ \ \ \ \ \ \ (set-message "No parent" "No parent")

    \ \ \ \ \ \ \ \ (compare-with-older parent))))

    \;

    (tm-define (git-compare-with-master name)

    \ \ (let* ((name-s (string-replace (url-\<gtr\>string name)

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (string-append
    gitroot "/")

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ "\|"))

    \ \ \ \ \ \ \ \ \ (file-buffer-s (tmfs-url-commit (git-commit-master)

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ name-s))

    \ \ \ \ \ \ \ \ \ (master (string-\<gtr\>url file-buffer-s)))

    \ \ \ \ (compare-with-older master)))
  </scm-chunk>

  <subsection|git status>

  <\scm-chunk|git-utils.scm|true|true>
    (tm-define (git-status)

    \ \ (let* ((cmd (string-append callgit " status --porcelain"))

    \ \ \ \ \ \ \ \ \ (ret1 (eval-system cmd))

    \ \ \ \ \ \ \ \ \ (ret2 (string-split ret1 #\\nl)))

    \ \ \ \ (define (convert name)

    \ \ \ \ \ \ (let* ((status (string-take name 2))

    \ \ \ \ \ \ \ \ \ \ \ \ \ (filename (string-drop name 3))

    \ \ \ \ \ \ \ \ \ \ \ \ \ (file (if (or (string-starts? status "A")

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (string-starts?
    status "?"))

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ filename

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ($link
    (tmfs-url-git_history (url-\<gtr\>tmfs-string\ 

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (string-append\ 

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ gitroot
    "/" filename)))

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (utf8-\<gtr\>cork
    filename)))))

    \ \ \ \ \ \ \ \ (list status file)))

    \ \ \ \ (and (\<gtr\> (length ret2) 0)

    \ \ \ \ \ \ \ \ \ (string-null? (cAr ret2))

    \ \ \ \ \ \ \ \ \ (map convert (cDr ret2)))))
  </scm-chunk>

  <subsection|git commit>

  <\scm-chunk|git-utils.scm|true|false>
    (tm-define (git-commit message)

    \ \ (let* ((cmd (string-append

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ callgit " commit -m \\"" message "\\""))

    \ \ \ \ \ \ \ \ \ (ret (eval-system cmd)))

    \ \ \ \ ;; (display ret)

    \ \ \ \ (set-message (string-append callgit " commit") message))

    \ \ (git-show-status))

    \;

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ;;; low level routines for git (involving hash code)

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    (tm-define (git-show object)

    \ \ (let* ((cmd (string-append callgit " show " object))

    \ \ \ \ \ \ \ \ \ (ret (eval-system cmd)))

    \ \ \ \ ;; (display* "\\n" cmd "\\n" ret "\\n")

    \ \ \ \ ret))

    \;

    (tm-define (git-commit-message hash)

    \ \ (let* ((cmd (string-append callgit " log -1 " hash))

    \ \ \ \ \ \ \ \ \ (ret (eval-system cmd)))

    \ \ \ \ (string-split ret #\\nl)))

    \;

    (tm-define (git-commit-parent hash)

    \ \ (let* ((cmd (string-append

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ callgit " log -2 --pretty=%H " hash))

    \ \ \ \ \ \ \ \ \ (ret1 (eval-system cmd))

    \ \ \ \ \ \ \ \ \ (ret2 (delete-tail-newline ret1))

    \ \ \ \ \ \ \ \ \ (ret3 (string-split ret2 #\\nl))

    \ \ \ \ \ \ \ \ \ (ret4 (cAr ret3)))

    \ \ \ \ ret4))

    \;

    (tm-define (git-commit-file-parent file hash)

    \ \ (let* ((cmd (string-append

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ callgit " log --pretty=%H "

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ gitroot "/" file))

    \ \ \ \ \ \ \ \ \ (ret (eval-system cmd))

    \ \ \ \ \ \ \ \ \ (ret2 (string-decompose

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ret (string-append hash "\\n"))))

    \ \ \ \ ;; (display ret2)

    \ \ \ \ (if (== (length ret2) 1)

    \ \ \ \ \ \ \ \ hash

    \ \ \ \ \ \ \ \ (string-take (second ret2) 40))))

    \;

    (tm-define (git-commit-master)

    \ \ (let* ((cmd (string-append callgit " log -1 --pretty=%H"))

    \ \ \ \ \ \ \ \ \ (ret (eval-system cmd)))

    \ \ \ \ (delete-tail-newline ret)))

    \;

    (tm-define (git-commit-diff parent hash)

    \ \ (let* ((cmd (if (== parent hash)

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (string-append

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ callgit " show " hash

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ " --numstat --pretty=oneline")

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (string-append

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ callgit " diff --numstat "

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ parent " " hash)))

    \ \ \ \ \ \ \ \ \ (ret (eval-system cmd))

    \ \ \ \ \ \ \ \ \ (ret2 (if (== parent hash)

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (cdr (string-split ret #\\nl))

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (string-split ret #\\nl))))

    \ \ \ \ (define (convert body)

    \ \ \ \ \ \ (let* ((alist (string-split body #\\ht)))

    \ \ \ \ \ \ \ \ (if (== (first alist) "-")

    \ \ \ \ \ \ \ \ \ \ \ \ (list 0 0 (utf8-\<gtr\>cork (third alist))

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (string-length (third alist)))

    \ \ \ \ \ \ \ \ \ \ \ \ (list (string-\<gtr\>number (first alist))

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (string-\<gtr\>number (second alist))

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ($link (tmfs-url-commit hash "\|"
    (third alist))

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (utf8-\<gtr\>cork
    (third alist)))

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (string-length (third alist))))))

    \ \ \ \ (and (\<gtr\> (length ret2) 0)

    \ \ \ \ \ \ \ \ \ (string-null? (cAr ret2))

    \ \ \ \ \ \ \ \ \ (map convert (cDr ret2)))))
  </scm-chunk>

  \;
</body>

<initial|<\collection>
</collection>>

<\references>
  <\collection>
    <associate|auto-1|<tuple|1|?>>
    <associate|auto-10|<tuple|4.5|?>>
    <associate|auto-11|<tuple|4.6|?>>
    <associate|auto-2|<tuple|2|?>>
    <associate|auto-3|<tuple|3|?>>
    <associate|auto-4|<tuple|3.1|?>>
    <associate|auto-5|<tuple|4|?>>
    <associate|auto-6|<tuple|4.1|?>>
    <associate|auto-7|<tuple|4.2|?>>
    <associate|auto-8|<tuple|4.3|?>>
    <associate|auto-9|<tuple|4.4|?>>
    <associate|chunk--1|<tuple||?>>
    <associate|chunk-g-1|<tuple|g|?>>
    <associate|chunk-gi-1|<tuple|gi|?>>
    <associate|chunk-git--1|<tuple|git-|?>>
    <associate|chunk-git-1|<tuple|git|?>>
    <associate|chunk-git-u-1|<tuple|git-u|?>>
    <associate|chunk-git-ut-1|<tuple|git-ut|?>>
    <associate|chunk-git-uti-1|<tuple|git-uti|?>>
    <associate|chunk-git-util-1|<tuple|git-util|?>>
    <associate|chunk-git-utils-1|<tuple|git-utils|?>>
    <associate|chunk-git-utils.-1|<tuple|git-utils.|?>>
    <associate|chunk-git-utils.s-1|<tuple|git-utils.s|?>>
    <associate|chunk-git-utils.sc-1|<tuple|git-utils.sc|?>>
    <associate|chunk-git-utils.scm-1|<tuple|git-utils.scm|?>>
    <associate|chunk-git-utils.scm-10|<tuple|git-utils.scm|?>>
    <associate|chunk-git-utils.scm-2|<tuple|git-utils.scm|?>>
    <associate|chunk-git-utils.scm-3|<tuple|git-utils.scm|?>>
    <associate|chunk-git-utils.scm-4|<tuple|git-utils.scm|?>>
    <associate|chunk-git-utils.scm-5|<tuple|git-utils.scm|?>>
    <associate|chunk-git-utils.scm-6|<tuple|git-utils.scm|?>>
    <associate|chunk-git-utils.scm-7|<tuple|git-utils.scm|?>>
    <associate|chunk-git-utils.scm-8|<tuple|git-utils.scm|?>>
    <associate|chunk-git-utils.scm-9|<tuple|git-utils.scm|?>>
  </collection>
</references>