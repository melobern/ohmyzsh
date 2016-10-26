GIT_AUTO_FETCH_INTERVAL=${GIT_AUTO_FETCH_INTERVAL:=60}

function git-fetch-all {
  (`git rev-parse --is-inside-work-tree 2>/dev/null` &&
  dir=`git rev-parse --git-dir` &&
  [[ ! -f $dir/NO_AUTO_FETCH ]] &&
  (( `date +%s` - `date -r $dir/FETCH_LOG +%s` > $GIT_AUTO_FETCH_INTERVAL )) &&
  git fetch --all &>! $dir/FETCH_LOG &)
}

function git-auto-fetch {
  `git rev-parse --is-inside-work-tree 2>/dev/null` || return
  guard="`git rev-parse --git-dir`/NO_AUTO_FETCH"

  (rm $guard 2>/dev/null &&
    echo "${fg_bold[green]}enabled${reset_color}") ||
  (touch $guard &&
    echo "${fg_bold[red]}disabled${reset_color}")
}

eval "original-$(declare -f zle-line-init)"

function zle-line-init () {
  git-fetch-all
  original-zle-line-init
}
zle -N zle-line-init
