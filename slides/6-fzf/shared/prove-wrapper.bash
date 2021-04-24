# prove
_fzf_complete_prove() {
  _fzf_complete --reverse --multi --prompt="prove> " -- "$@" < <(
      fd -e t
  )
}

_fzf_complete_prove_post() {
    awk '{print $1}'
}

[ -n "$BASH" ] && complete -F _fzf_complete_prove -o default -o bashdefault prove
