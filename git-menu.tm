<TeXmacs|1.99.5>

<style|<tuple|generic|literate>>

<\body>
  <doc-data|<doc-title|Tigmacs>|<doc-author|<author-data|<author-name|Darcy
  SHEN>>>>

  <name|Tigmacs> is a <TeXmacs> plugin that provides <name|Git>
  functionality. I love the ncurse tool <name|Tig>. <name|Tigmacs>, just as
  the name indicates, mimics the behavior of <name|Tig>.

  <section|Module>

  <\scm-chunk|git-menu.scm|false|true>
    (texmacs-module (utils git git-menu)

    \ \ (:use (utils git git-utils)

    \ \ \ \ \ \ \ \ (utils git git-tmfs)))
  </scm-chunk>

  <section|Menu>

  <\scm-chunk|git-menu.scm|true|false>
    (menu-bind

    \ \ texmacs-extra-menu

    \ \ (former)

    \ \ (=\<gtr\> "Git"

    \ \ \ \ (when (git-versioned? (current-buffer))

    \ \ \ \ \ \ \ \ \ ("Log" (git-show-log))

    \ \ \ \ \ \ \ \ \ ("Status" (git-show-status))

    \ \ \ \ \ \ \ \ \ ("Commit" (git-interactive-commit))

    \ \ \ \ \ \ \ \ \ ---

    \ \ \ \ \ \ \ \ \ (assuming (buffer-to-add? (current-buffer))

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ("Add" (git-add (current-buffer))))

    \ \ \ \ \ \ \ \ \ (assuming (buffer-to-unadd? (current-buffer))

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ("Undo Add" (git-unadd
    (current-buffer))))

    \ \ \ \ \ \ \ \ \ (when (buffer-histed? (current-buffer))

    \ \ \ \ \ \ \ \ \ \ \ ("History" (git-history (current-buffer))))

    \ \ \ \ \ \ \ \ \ (=\<gtr\> "Compare"

    \ \ \ \ \ \ \ \ \ \ \ \ \ (assuming (buffer-tmfs? (current-buffer))

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ("With current version"

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (git-compare-with-current
    (current-buffer))))

    \ \ \ \ \ \ \ \ \ \ \ \ \ (assuming (buffer-tmfs? (current-buffer))

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ("With parent version"

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (git-compare-with-parent
    (current-buffer))))

    \ \ \ \ \ \ \ \ \ \ \ \ \ (when (and (not (buffer-tmfs?
    (current-buffer)))

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (buffer-has-diff?
    (current-buffer)))

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ("With the master"

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (git-compare-with-master
    (current-buffer))))))))
  </scm-chunk>
</body>

<initial|<\collection>
</collection>>

<\references>
  <\collection>
    <associate|auto-1|<tuple|1|?>>
    <associate|auto-2|<tuple|2|?>>
    <associate|chunk-git-menu.scm-1|<tuple|git-menu.scm|?>>
    <associate|chunk-git-menu.scm-2|<tuple|git-menu.scm|?>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|toc>
      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|1<space|2spc>Module>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-1><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|2<space|2spc>Menu>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-2><vspace|0.5fn>
    </associate>
  </collection>
</auxiliary>