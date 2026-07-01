# Git Workflow Notes
*Started 2026-06-29 -- P0-W1-D3*

---

## Identity Setup
```bash
git config --global user.name "Fayazur Rahman"
git config --global user.email "xxx@gmail.com"
git config --global init.defaultBranch main
```

## SSH Authentication
- Generate: `ssh-keygen -t ed25519 -C "email"`
- Add to agent: `eval "$(ssh-agent -s)"` then `ssh-add ~/.ssh/id_ed25519`
- Add public key to GitHub: Settings → SSH and GPG keys → New SSH key
- Test: `ssh -T git@github.com`
- Check your current remote URL: `git remote -v`
- If it shows https://, switch to SSH: `git remote set-url origin git@github.com:fayazur-rahman/xyz.git`
- Verify: `git remote -v` Now all pushes/pulls use SSH.

## The Core Rule
**main is always deployable.** Never work directly on main.

## Branch Workflow
```bash
git switch -c feature/name             # create + switch to branch "-c" for create
git branch                             # list local branches
git branch -a                          # list all branches (incl. remote)
git switch main                        # switch back to main
git merge feature/name                 # merge branch into current
git branch -d feature/name             # delete branch in local
git push origin --delete new/feature   # delete a branch from remote
```

## Daily Workflow Commands
```bash
git status                    # what's changed?
git diff                      # see exact changes (unstaged)
git add .                     # stage all changes
git add filename              # stage one file
git commit -m "message"       # commit with inline message
git push origin branch-name   # push branch to GitHub
git log --oneline             # compact commit history
```

## Commit & Branching Model (summary)

**Branching:** main is always deployable. Work happens on feature/* branches,
merged back when done, then deleted.

**Commit messages:** imperative mood ("Add X", "Fix Y", "Remove Z").
Explain WHY in the body when the change isn't self-evident from the diff.

**Undo decision rule:**
| Situation | Command |
|---|---|
| Already pushed / shared | `git revert <sha>` |
| Local only, not pushed | `git reset --soft/--hard <sha>` |

**Tags:** annotated only (`git tag -a vX.Y.Z -m "message"`), used to mark
release points. Push explicitly with `git push origin <tag>` or `--tags`.
```bash
git tag -a v0.1.0 -m "Phase 0 complete: Linux, Git, Docker fundamentals"
git push origin v0.1.0          # push a single tag
git push --tags                 # push all tags
git tag                         # list all tags
git show v0.1.0                 # see what the tag points to
```

**Daily commands:** `git status`, `git diff`, `git stash` / `git stash pop`.
```bash
git status           # what's changed, what's staged, what branch am I on
git diff             # exact line-by-line changes, unstaged
git diff --staged    # exact line-by-line changes, staged (about to be committed)
git stash            # save current changes, return to clean working dir
git stash list       # see what's stashed
git stash pop        # bring back the most recent stash, remove it from the list
git stash apply      # bring back the most recent stash, keep it in the list
git stash drop       # remove a single entry
git stash clear      # remove all entries
```



