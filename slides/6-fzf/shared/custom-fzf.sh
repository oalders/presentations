# Keep fzf config and functions together
export FZF_DEFAULT_COMMAND='fdfind --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS='--multi --pointer ">>"'

f () {
    fzf --bind='ctrl-/:toggle-preview' --preview "batcat --style=numbers --color=always --line-range :500 {}" "$@"
}
