_fzf_complete_apt-get() {
  _fzf_complete --reverse --prompt="apt-get> " -- "$@" < <(
    echo dist-upgrade
    echo install
    echo purge
    echo remove
    echo update
  )
}

_fzf_complete_apt-get_post() {
    awk '{print $1}'
}

[ -n "$BASH" ] && complete -F _fzf_complete_apt-get -o default -o bashdefault apt-get
