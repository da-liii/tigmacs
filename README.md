# Tigmacs: TeXmacs Git Plugin

## Installation
``` bash
mkdir -p $HOME/.TeXmacs/progs/utils
git clone git@github.com:sadhen/tigmacs.git $HOME/.TeXmacs/progs/utils/git
echo "(use-modules (utils git git-menu))" >> $HOME/.TeXmacs/progs/my-init-texmacs.scm
```

## Screenshot
### git status
![](screenshots/git-status.png)
### git log
![](screenshots/git-log.png)
### git diff
![](screenshots/git-diff.png)
### git log (current-buffer)
![](screenshots/git-history.png)
