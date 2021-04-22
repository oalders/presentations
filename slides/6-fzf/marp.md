---
marp: true
theme: default
---

# fzf - command-line fuzzy finder 

*Make your workflow matchier*

Olaf Alders
March 2021

---

# Problem: It can be hard to find a thing

---

# fzf helps you find things, like files

but it matches on other things as well.

* files
* `kill` integration
* `ssh` integration
* `vim` integration
* `VSCode` integration
* `unset` environment variables
* `history` search via `ctrl-r`

---

# Installation

* `git`
* Package managers
* `homebrew`
* As a `vim` plugin

---

# Wait, install via `vim`?

```
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
```

Now, `fzf` will be installed for you via `:PlugInstall`

Source key bindings and bash completion:

```
[ -f "$HOME"/.vim/plugged/fzf/shell/key-bindings.bash ] && source "$HOME"/.vim/plugged/fzf/shell/key-bindings.bash
[ -f "$HOME"/.vim/plugged/fzf/shell/completion.bash ] && source "$HOME"/.vim/plugged/fzf/shell/completion.bash
```

---

# Can I do this without a vim session?

Install via command line:

```
vim +'PlugInstall --sync' +qa
```

Add the above command to your dot-files in order to automate your `fzf` installation.

---

# Usage

* `command **<tab>`
* Use `<tab>` to select multiple lines
* fuzzy matching enabled by default
* Prefix a word with `'` to get an exact (case-insensitive) match
  ```
  kill -9 **<tab>
  > `macdown
  ```
  The above will select all processes running `MacDown`
* `<return>` to exit and pass selections to your command

---

# More Advanced Matching

* `.json$`
* `^lab`
* `^lab | ^bin`

---

# Handy Shortcuts

## Emulate `tig`
```
git log --oneline | fzf --multi --preview 'git show {+1}'
```

---

# vim

* `:Files ~`
* `:GFiles` (`git ls-files`)
* `:GFiles?` (`git status`)
* `:Buffers`
* `:Colors`
* `:Lines`
* `:History`
* `:History:`
* `:Commits` (requires Fugitive.vim)
* `:Commands`
* `:Filetypes`
* `:Rg`

---

# vim fullscreen
* Add a trailing `!` to your command: `:GFiles!`

---
# vim preview windows

* Toggle preview window via `ctrl-/`

---
# Grep Repository (via ripgrep)

`:Rg some text`

---
