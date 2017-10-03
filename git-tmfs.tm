<TeXmacs|1.99.5>

<style|<tuple|generic|literate>>

<\body>
  <doc-data|<doc-title|tmfs for Git>>

  <\scm-chunk|git-tmfs.scm|false|true>
    (texmacs-module (utils git git-tmfs)

    \ \ (:use (utils git git-utils)))
  </scm-chunk>

  <section|Menu>

  <shell|<tree|/|<tree|/git|/git/log|/git/status>|/git_history|/commit>>

  \;

  <todo|What is the meaning of cursor-history-add>

  <\scm-chunk|git-tmfs.scm|true|true>
    (tm-define (git-show-log)

    \ \ (cursor-history-add (cursor-path))

    \ \ (revert-buffer "tmfs://git/log"))

    \;

    (tm-define (git-show-status)

    \ \ (cursor-history-add (cursor-path))

    \ \ (revert-buffer "tmfs://git/status"))

    \;

    (tm-define (git-history name)

    \ \ (cursor-history-add (cursor-path))

    \ \ (with s (url-\<gtr\>tmfs-string name)

    \ \ \ \ \ \ \ \ (revert-buffer (tmfs-url-git_history s))))
  </scm-chunk>

  <section|Handlers>

  <section|Route>

  <subsection|<shell|/git/*>>

  <\scm-chunk|git-tmfs.scm|true|true>
    (tm-define ($staged-file status file)

    \ \ (cond ((string-starts? status "A")

    \ \ \ \ \ \ \ \ \ (list 'concat "new file: \ \ " file (list 'new-line)))

    \ \ \ \ \ \ \ \ ((string-starts? status "M")

    \ \ \ \ \ \ \ \ \ (list 'concat "modified: \ \ " file (list 'new-line)))

    \ \ \ \ \ \ \ \ ((string-starts? status "R")

    \ \ \ \ \ \ \ \ \ (list 'concat "renamed: \ \ \ " file (list 'new-line)))

    \ \ \ \ \ \ \ \ (else "")))

    \;

    (tm-define ($unstaged-file status file)

    \ \ (cond ((string-ends? status "M")

    \ \ \ \ \ \ \ \ \ (list 'concat "modified: \ \ " file (list 'new-line)))

    \ \ \ \ \ \ \ \ (else "")))

    \;

    (tm-define ($untracked-file status file)

    \ \ (cond ((== status "??")

    \ \ \ \ \ \ \ \ \ (list 'concat file (list 'new-line)))

    \ \ \ \ \ \ \ \ (else "")))

    \;

    (tm-define (git-status-content)

    \ \ (with s (git-status)

    \ \ \ \ \ \ \ \ ($generic

    \ \ \ \ \ \ \ \ \ ($when (not s)

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ "Not git status available!")

    \ \ \ \ \ \ \ \ \ ($when s

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ($tmfs-title "Git Status")

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ($description-long

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ($describe-item "Changes to be
    commited"

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ($for
    (x s)

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ($with
    (status file) x

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ($staged-file
    status

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ file))))

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ($describe-item "Changes not staged for
    commit"

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ($for
    (x s)

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ($with
    (status file) x

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ($unstaged-file
    status

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ file))))

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ($describe-item "Untracked files"

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ($for
    (x s)

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ($with
    (status file) x

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ($untracked-file
    status

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ file)))))))))

    \;

    \;

    (tm-define (git-log-content)

    \ \ (with h (git-log)

    \ \ \ \ \ \ \ \ ($generic

    \ \ \ \ \ \ \ \ \ ($tmfs-title "Git Log")

    \ \ \ \ \ \ \ \ \ ($when (not h)

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ "This directory is not under version
    control.")

    \ \ \ \ \ \ \ \ \ ($when h

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ($description-long

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ($for (x h)

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ($with (date by msg commit)
    x

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ($describe-item

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ($inline
    "Commit " commit

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ "
    by " (utf8-\<gtr\>cork by)

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ "
    on " date)

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (utf8-\<gtr\>cork
    msg)))))))))

    \;

    (tmfs-title-handler (git name doc)

    \ \ (cond ((== name "status") "Git Status")

    \ \ \ \ \ \ \ \ ((== name "log") "Git Log")

    \ \ \ \ \ \ \ \ (else "unknown")))

    \;

    (tmfs-load-handler (git name)

    \ \ (cond ((== name "status")

    \ \ \ \ \ \ \ \ \ (git-status-content))

    \ \ \ \ \ \ \ \ ((== name "log")

    \ \ \ \ \ \ \ \ \ (git-log-content))

    \ \ \ \ \ \ \ \ (else '())))
  </scm-chunk>

  <subsection|<shell|/git_history/*>>

  <\scm-chunk|git-tmfs.scm|true|true>
    (tm-define (tmfs-url-git_history . content)

    \ \ (string-append "tmfs://git_history/"

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (string-concatenate content)))

    \;

    (tmfs-title-handler (git_history name doc)

    \ \ (with u (tmfs-string-\<gtr\>url name)

    \ \ \ \ \ \ \ \ (string-append (url-\<gtr\>system (url-tail u)) " -
    History")))

    \;

    (tmfs-load-handler (git_history name)

    \ \ (with u (tmfs-string-\<gtr\>url name)

    \ \ \ \ \ \ \ \ (with h (buffer-log u)

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ ($generic

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ($tmfs-title "History of "

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ($link
    (url-\<gtr\>unix u)

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ($verbatim
    (utf8-\<gtr\>cork (url-\<gtr\>system (url-tail u))))))

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ($when (not h)

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ "This file is not under
    version control.")

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ($when h

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ($description-long

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ($for (x h)

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ($with (date by
    msg commit) x

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ($describe-item

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ($inline
    "Commit " commit

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ "
    by " by

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ "
    on " date)

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (utf8-\<gtr\>cork
    msg))))))))))
  </scm-chunk>

  <subsection|<shell|/commit>>

  <\scm-chunk|git-tmfs.scm|true|true>
    (tm-define (tmfs-url-commit . content)

    \ \ (string-append "tmfs://commit/"

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (string-concatenate content)))

    (tmfs-format-handler (commit name)

    \ \ (if (string-contains name "\|")

    \ \ \ \ \ \ (with u (tmfs-string-\<gtr\>url (tmfs-cdr (string-replace
    name "\|" "/")))

    \ \ \ \ \ \ \ \ \ \ \ \ (url-format u))

    \ \ \ \ \ \ (url-format (tmfs-string-\<gtr\>url name))))

    \;

    (tmfs-load-handler (commit name)

    \ \ (define (sum2 x)

    \ \ \ \ (+ (first x) (second x)))

    \ \ (define (length-of-2col x)

    \ \ \ \ (+ (string-length (number-\<gtr\>string (sum2 x)))

    \ \ \ \ \ \ \ (fourth x)))

    \ \ 

    \ \ (if (string-contains name "\|")

    \ \ \ \ \ \ (git-show (string-replace name "\|" ":"))

    \ \ \ \ \ \ (let* ((m (git-commit-message name))

    \ \ \ \ \ \ \ \ \ \ \ \ \ (p (git-commit-parent name))

    \ \ \ \ \ \ \ \ \ \ \ \ \ (d (git-commit-diff p name))

    \ \ \ \ \ \ \ \ \ \ \ \ \ (nr (length d))

    \ \ \ \ \ \ \ \ \ \ \ \ \ (ins (list-fold + 0 (map first d)))

    \ \ \ \ \ \ \ \ \ \ \ \ \ (del (list-fold + 0 (map second d)))

    \ \ \ \ \ \ \ \ \ \ \ \ \ (maxv (list-fold max 0 (map sum2 d)))

    \ \ \ \ \ \ \ \ \ \ \ \ \ (maxs (- 81 (list-fold max 0 (map
    length-of-2col d)))))

    \ \ \ \ \ \ \ \ ($generic

    \ \ \ \ \ \ \ \ \ ($tmfs-title "Commit Message of " (string-take name 7))

    \ \ \ \ \ \ \ \ \ (if (== name p)

    \ \ \ \ \ \ \ \ \ \ \ \ \ "parent 0"

    \ \ \ \ \ \ \ \ \ \ \ \ \ `(concat "parent "

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ,($link (tmfs-url-commit p)
    p)))

    \ \ \ \ \ \ \ \ \ (list 'new-line)

    \ \ \ \ \ \ \ \ \ ($for (x m) `(concat ,(utf8-\<gtr\>cork x) ,(list
    'new-line)))

    \ \ \ \ \ \ \ \ \ "-----"

    \ \ \ \ \ \ \ \ \ (list 'new-line)

    \ \ \ \ \ \ \ \ \ `(verbatim

    \ \ \ \ \ \ \ \ \ \ \ (tabular

    \ \ \ \ \ \ \ \ \ \ \ \ (tformat

    \ \ \ \ \ \ \ \ \ \ \ \ \ (cwith "1" "-1" "1" "-1"

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ cell-lsep "0pt")

    \ \ \ \ \ \ \ \ \ \ \ \ \ ,(cons 'table

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (map (lambda (x) (get-row-from-x
    x maxs maxv)) d)))))

    \ \ \ \ \ \ \ \ \ (list 'new-line)

    \ \ \ \ \ \ \ \ \ `(concat ,nr " files changed, "

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ,ins

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ " insertions(" (verbatim (with color
    green "+")) "), "

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ,del

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ " deletions(" (verbatim (with color
    red "-")) ")")))))

    \;

    (tm-define (string-\<gtr\>commit str name)

    \ \ (if (string-null? str) '()

    \ \ \ \ \ \ (with alist (string-split str #\\nl)

    \ \ \ \ \ \ \ \ \ \ \ \ (list (string-take (first alist) 20)

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (second alist)

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (third alist)

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ($link (tmfs-url-commit (fourth
    alist)

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (if
    (string-null? name)

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ""

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (string-append
    "\|" name)))

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (string-take (fourth
    alist) 7))))))
  </scm-chunk>

  <section|Routines>

  <\scm-chunk|git-tmfs.scm|true|false>
    (define (string-repeat str n)

    \ \ (do ((i 1 (1+ i))

    \ \ \ \ \ \ \ (ret "" (string-append ret str)))

    \ \ \ \ \ \ ((\<gtr\> i n) ret)))

    \;

    (define (get-row-from-x x maxs maxv)

    \ \ (define (get-length nr)

    \ \ \ \ (let* ((ret (/ (* nr (min maxs maxv)) maxv)))

    \ \ \ \ \ \ (if (and (\<gtr\> ret 0) (\<less\> ret 1)) 1

    \ \ \ \ \ \ \ \ \ \ ret)))

    \ \ `(row (cell ,(third x))

    \ \ \ \ \ \ \ \ (cell ,(number-\<gtr\>string (+ (first x) (second x))))

    \ \ \ \ \ \ \ \ (cell (concat (with color green

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ,(string-repeat
    "+"

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (get-length
    (first x))))

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (with color red

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ,(string-repeat
    "-"

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (get-length
    (second x))))))))
  </scm-chunk>
</body>

<initial|<\collection>
</collection>>

<\references>
  <\collection>
    <associate|auto-1|<tuple|1|?>>
    <associate|auto-2|<tuple|2|?>>
    <associate|auto-3|<tuple|3|?>>
    <associate|auto-4|<tuple|3.1|?>>
    <associate|auto-5|<tuple|3.2|?>>
    <associate|auto-6|<tuple|3.3|?>>
    <associate|auto-7|<tuple|4|?>>
    <associate|chunk-git-tmfs.scm-1|<tuple|git-tmfs.scm|?>>
    <associate|chunk-git-tmfs.scm-2|<tuple|git-tmfs.scm|?>>
    <associate|chunk-git-tmfs.scm-3|<tuple|git-tmfs.scm|?>>
    <associate|chunk-git-tmfs.scm-4|<tuple|git-tmfs.scm|?>>
    <associate|chunk-git-tmfs.scm-5|<tuple|git-tmfs.scm|?>>
    <associate|chunk-git-tmfs.scm-6|<tuple|git-tmfs.scm|?>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|toc>
      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|1<space|2spc>Menu>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-1><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|2<space|2spc>Handlers>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-2><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|3<space|2spc>Route>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-3><vspace|0.5fn>

      <with|par-left|<quote|1tab>|3.1<space|2spc><with|mode|<quote|prog>|prog-language|<quote|shell>|font-family|<quote|rm>|/git/*>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-4>>

      <with|par-left|<quote|1tab>|3.2<space|2spc><with|mode|<quote|prog>|prog-language|<quote|shell>|font-family|<quote|rm>|/git_history/*>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-5>>

      <with|par-left|<quote|1tab>|3.3<space|2spc><with|mode|<quote|prog>|prog-language|<quote|shell>|font-family|<quote|rm>|/commit>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-6>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|4<space|2spc>Routines>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-7><vspace|0.5fn>
    </associate>
  </collection>
</auxiliary>