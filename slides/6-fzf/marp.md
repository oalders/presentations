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

# Handy Shortcuts

## Emulate `tig`
```
git log --oneline | fzf --multi --preview 'git show {+1}'
```

---

# vim

* `:Files ~`
* `:GFiles`
* `:Buffers`
* `:Colors`
* `:Lines`
* `:History`
* `:History:`
* `:Commits` (requires Fugitive.vim)
* `:Commands`
* `:Filetypes`

Toggle preview window via `ctrl-/`

---

## vim Fullscreen

Add a trailing `!` to your command: `:GFiles!`