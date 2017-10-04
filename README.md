# Tigmacs: TeXmacs Git Plugin
[![Join the chat at https://gitter.im/texmacs/Lobby](https://badges.gitter.im/texmacs/Lobby.svg)](https://gitter.im/texmacs/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)


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
