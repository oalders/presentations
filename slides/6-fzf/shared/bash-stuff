commands() {
    SELECTION=$(cat shared/commands.txt | fzf --reverse)
    COMMAND=$(echo $SELECTION | cut -d'#' -f2-)

    echo "Running $COMMAND"
    eval $COMMAND
}
