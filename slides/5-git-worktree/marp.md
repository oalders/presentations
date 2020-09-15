---
marp: true
---

# git worktree

*Manage multiple working trees attached to the same repository*

Olaf Alders
September 2020

---

# Problem: Working in multiple branches of the same repository

---

# Solution #1

* *Work on branch feature-1*
* *Something else comes up. It requires a new branch.*
* `git stash`
* `git checkout --branch feature-2 origin/master`
* *Work on branch feature-2*
* *...*
* *Switch back to original branch*
* `git checkout feature-1`
* `git stash pop`

---

# Pros:

* Easy workflow for simple changes
* Good for small repositories

# Cons:

* You can only be in one branch at any given time
* You can't always pop the stash cleanly, depending on the state of your repository
* The more branches you have, the more complicated your stash becomes

Note: You can avoid the stash by using WIP commits, but those can be prone to errors to. You may accidentally push them to your origin repository or forget to rebase them away before you finalize your work.

---

# Solution #2

* Clone a new repository for each new feature

---

# Pros:

* Work in multiple repositories simultaneously
* Avoid needing the stash

---

# Cons:

* With larger repositories you can quickly run out of disk space.
* Your clones will be agnostic about each other.
  * You'll need to track where your clones live.
  * There are some tools to help with this, like `App::GitGot`.
* `git` hooks will need to be set up on each clone.

---

# Solution #3

* `git add worktree`

---

# Pros:

* Work in multiple repositories simultaneously
* Avoid needing the stash
* Your `git` trees will know about each other

---

# Cons:

---

# List Your worktrees

```bash
$ git worktree list
/vagrant                                            1386af9a83 [master]
/home/oalders/worktree/oalders/password-setup-copy  862d31cefd [oalders/password-setup-copy]
/home/oalders/worktree/oalders/trust                59f6e5dfec [oalders/trust]
```

```bash
$ du -sh /vagrant/
17G	/vagrant/
```

```bash
$ du -sh /home/oalders/worktree/oalders/password-setup-copy
1.9G	/home/oalders/worktree/oalders/password-setup-copy
```
