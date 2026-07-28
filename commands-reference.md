# Linux Commands Reference
*Personal cheat sheet — started 2026-07-19*

## Linux — Navigation
| Command | What it does | When I'd use it |
|---|---|---|
| `pwd` | Prints current directory | First thing after SSH — "where am I?" |
| `ls -ltrh` | Long list, by time, newest last, human sizes | In /var/log — "what changed most recently?" |
| `ls -la` | Long list incl. hidden files | Checking ~/.ssh, dotfiles, anything starting with . |
| `cd -` | Jump back to previous directory | Bouncing between /etc/nginx and /var/log |
| `mkdir -p a/b/c` | Create nested path, no error if exists | Scripts, project scaffolding |
| `cp -r src dst` | Copy directory recursively | Backing up a config dir before editing it |
| `find /path -name "*.log" -mtime -7 -type f` | Only File types matching name, changed <7 days | "Which logs are even active on this box?" |
| `find /path -size +10M` | Files over 10MB | Disk-full incidents — where did the space go |

## Linux — Filesystem map
- `/etc` = config (all text — this is why IaC works)
- `/var/log` = logs (home base during incidents)
- `/var/www` = web content
- `~` = home; `~/.ssh` = keys
- `/proc` = live kernel state as fake files (`/proc/meminfo`)
- `/tmp` = scratch, wiped on reboot
- `/usr/bin`, `/usr/local/bin` = installed binaries

## Linux — Reading logs
| Command | What it does | When I'd use it |
|---|---|---|
| `tail -n 50 file` | Last 50 lines | DEFAULT log move — errors are recent |
| `tail -f file` | Follow live | Reproduce a bug while watching it appear |
| `less file` | Scrollable viewer (`/` search, `q` quit) | Exploring a big unfamiliar file |
| `head -n 20 file` | First 20 lines | Checking a file's format |
| `journalctl --no-pager` | systemd logs (syslog replacement) | WSL2/modern Ubuntu where /var/log/syslog is absent |
| `journalctl --since "1 hour ago"` | Time-bounded logs | Incident scoping — "what happened since it broke?" |

## Linux — Filtering
| Command | What it does | When I'd use it |
|---|---|---|
| `grep -i "error"` | Case-insensitive match | ALWAYS use -i; apps mix ERROR/Error/error |
| `grep -n` | Show line numbers | Pointing a teammate at an exact config line |
| `grep -r "text" /dir` | Recursive across a tree | "Which config file mentions this hostname?" |
| `grep -v "healthcheck"` | Invert — hide noise | Stripping heartbeat spam from access logs |
| `grep -c` | Count matches | Fast "is this getting worse?" check |
| `grep -C 5 "error"` | 5 lines context both sides | Error says WHAT failed; context says what was attempted |

## Linux — Pipes
- `|` sends left output into right input. Many small tools > one big tool.
- `sort | uniq -c` — always paired; uniq only collapses ADJACENT lines.
- **The pipeline of the trade:**
  `tail -n 500 file | awk '{print $N}' | sort | uniq -c | sort -rn | head -10`
  → "top N most frequent values in field N" — finds the noisy IP,
    the failing endpoint, the most common error. Change field, same shape.
- `tail -n 200 f | grep -i error | wc -l` — "how many errors recently?"

## Process — the log-reading reflex (Day 1)
1. `pwd` / `cd /var/log` — get to where truth is written
2. `ls -ltrh` — what's active and recent?
3. `tail -n 100 <file>` — never `cat` a production log
4. `grep -i` for the symptom keyword — always -i
5. `grep -C 5` around the hit — get the context
6. `| sort | uniq -c | sort -rn` — is it one event or a flood?
7. Write down what I found BEFORE I start fixing

## Gotchas / traps hit today
- `/var/log/syslog` may not exist on WSL2 → use `journalctl --no-pager`
- `uniq -c` needs `sort` first or it silently under-counts
- `find -mtime -7` = last 7 days; `+7` = older than 7; bare `7` = exactly day 7
- `rm` has no undo. Run `ls` with the pattern first, every time.
- `grep "error"` vs `grep -i "error"` gave different counts — a real missed bug

## Linux — Permissions
| Command | What it does | When I'd use it |
|---|---|---|
| `ls -l` | Shows mode, owner, group | FIRST move on any "permission denied" — diagnose before sudo |
| `chmod 600 file` | Owner read/write only | SSH keys, .env files, anything secret |
| `chmod 755 dir` | Owner full, others read+traverse | Directories and executable scripts |
| `chmod +x script.sh` | Make executable | Every bash script I write (Week 2) |
| `chown -R user:group path` | Change ownership recursively | The REAL fix for web-server permission errors (not 777) |
| `sudo <cmd>` | Run one command as root | Reading protected logs/configs. Hesitate to sudo a *fix*. |

**Mode cheat:** r=4 w=2 x=1 → 644 files · 755 dirs/scripts · 600 secrets · 777 = wrong
**Directory `x` = traverse, not execute.** No x on a dir = can't cd in, can't read anything inside, even if the file itself looks readable.
**Never `chmod 777` to fix a problem — fix ownership instead.**

## Linux — Processes
| Command | What it does | When I'd use it |
|---|---|---|
| `ps aux \| grep -v grep \| grep X` | Find a process (without matching the grep) | "Is it even running?" |
| `pgrep -a nginx` | PIDs + command lines by name | Cleaner than ps+grep |
| `top` / `htop` | Live CPU/mem view (`P`=cpu `M`=mem `q`=quit) | "Site is slow" — what's eating the box |
| `kill <PID>` | SIGTERM — graceful shutdown | ALWAYS TRY FIRST |
| `kill -9 <PID>` | SIGKILL — immediate, uncatchable | Last resort only; risks corrupt data / lost work |
| `pkill nginx` | Kill by name | Quick cleanup |

**ps columns:** USER (running as root?) · PID · %CPU/%MEM · RSS (real memory) · STAT (S=sleep R=run Z=zombie D=stuck-on-IO) · COMMAND (shows the actual args/config used)
**kill vs kill -9:** TERM is *received* and handled (flush, close, exit clean). KILL is not — kernel stops it mid-instruction. Same idea later: `docker stop` = TERM then KILL after 10s; K8s terminationGracePeriodSeconds.

## Linux — Services (systemd)
| Command | What it does | When I'd use it |
|---|---|---|
| `systemctl status X` | THE diagnostic — state + last log lines | First command in every service incident |
| `systemctl start/stop/restart X` | Control the service | restart = brief downtime |
| `systemctl reload X` | Re-read config, keep serving | Config change with no dropped connections |
| `systemctl enable X` | Start at boot | A working-but-disabled service dies on reboot |
| `systemctl is-active X` | One-word state + exit code | For SCRIPTS (Week 2 monitor.sh) |
| `journalctl -u X -n 50` | Last 50 lines for ONE unit | When status isn't enough |
| `journalctl -u X -f` | Follow live | Reproduce a bug while watching |
| `journalctl -u X -p err` | Errors and worse only | Cutting through noise fast |
| `journalctl -u X --no-pager \| grep -i error` | Pipe-able unit logs | Combining with Day 1 grep skills |
| `nginx -t` | Validate nginx config, gives FILE + LINE | Before any restart after a config edit |

**status fields:** `Loaded:` enabled/disabled (boot behaviour) · `Active:` running/dead/**failed** · `Main PID` · last ~10 log lines shown free

## Linux — Triage (disk / memory / network)
| Command | What it does | When I'd use it |
|---|---|---|
| `df -h` | Disk usage, watch `Use%` | FIRST 60 SECONDS — full disk fakes every other symptom |
| `du -sh /var/log/* \| sort -rh \| head -10` | What is filling the disk | Right after df says 100% |
| `free -h` | Memory — read `available`, NOT `free` | Linux caches RAM on purpose; free always looks low |
| `ss -tulpn` | Listening ports + owning process | "Is anything on :80?" / "what's blocking my port?" |
| `ip addr` | Interfaces and IPs | Networking checks |
| `curl -I localhost` | Headers only — is HTTP answering? | Fast up/down proof without dumping HTML |

## Process — the service-down reflex (Day 2) ★
1. `systemctl status <svc>` → read `Active:` + the auto-shown log tail
2. Not enough? `journalctl -u <svc> -n 50 --no-pager`
3. Config suspected? `nginx -t` (or the service's own validator) → exact file + line
4. Fix the cause
5. `systemctl restart <svc>`
6. **Confirm recovery:** `systemctl status` + `curl -I localhost` + `ss -tulpn | grep :80`
→ Same shape later: Docker container logs (P1), kubectl describe/logs (P3)

## Process — the permission-denied reflex (Day 2)
1. `ls -l <file>` — who owns it, what's the mode? DIAGNOSE FIRST
2. Wrong owner → `chown`. Wrong mode → `chmod`.
3. Can't cd into a dir I own? → missing `x` on the directory
4. sudo to *read* while investigating; don't sudo as the permanent fix

## Gotchas / traps hit today
- WSL2 needs `[boot] systemd=true` in /etc/wsl.conf + `wsl --shutdown` from PowerShell
- `ps aux | grep X` matches its own grep → add `grep -v grep`, or use `pgrep -a`
- nginx runs a root MASTER (binds :80) + www-data WORKERS (handle traffic) — least privilege in the wild
- Stopping one service produced 4 different symptoms (status/curl/ss/pgrep) — learn to run that backwards
- `free -h`: read `available`, not `free`
- Back up a config (`cp file file.bak`) BEFORE editing it. Every time.

## Git — Setup & SSH
| Command | What it does | When I'd use it |
|---|---|---|
| `git config --global user.name/.email` | Sets commit identity | Once per machine; wrong email = commits not linked to my GitHub |
| `git config --global --list` | Show all global config | "Why is this commit under the wrong name?" |
| `ssh-keygen -t ed25519 -C "label"` | Generate a key pair | New machine, or rotating a key |
| `eval "$(ssh-agent -s)"` | Start the key agent | Once per shell session (put it in .bashrc) |
| `ssh-add ~/.ssh/id_ed25519` | Load key into agent | Type passphrase once, not every push |
| `ssh-add -l` | List loaded keys | "Why is it asking for a password again?" |
| `ssh -T git@github.com` | Test GitHub auth | After adding a key. "No shell access" = SUCCESS |
| `ssh -vT git@github.com` | Verbose auth debug | Auth failing — shows which key was offered |
| `git remote set-url origin git@...` | Switch HTTPS → SSH | Cloned wrong and it keeps asking for a password |

**Key file permissions (SSH enforces these):** `~/.ssh` = 700 · private key = 600 · `.pub` = 644
**SSH URL uses a COLON:** `git@github.com:user/repo.git` (not a slash)

## Git — Daily Workflow
| Command | What it does | When I'd use it |
|---|---|---|
| `git status` | What's changed / staged / branch | Constantly. Before and after everything. |
| `git switch -c feature/x` | Create branch and move to it | Starting any piece of work |
| `git switch main` / `git switch -` | Move to a branch / previous branch | `switch -` is like `cd -` |
| `git branch` / `-a` / `-v` | List local / all / with last commit | "What was I working on?" |
| `git add .` / `git add file` | Stage changes | Before committing |
| `git diff` | Unstaged changes | "What did I actually change?" |
| `git diff --staged` | What I'm ABOUT to commit | EVERY commit — catches .env and debug lines |
| `git commit -m "msg"` | Commit staged changes | After review |
| `git merge feature/x` | Merge a branch into current | From main, after the work is verified |
| `git branch -d feature/x` | Delete merged branch (safe) | Immediately after merging |
| `git push origin --delete feature/x` | Delete the remote branch too | Same moment — don't leave stale branches |
| `git push -u origin main` | Push + set upstream tracking | First push of a branch; after that just `git push` |
| `git log --oneline --graph --all --decorate` | Visual history | Understanding what merged where |

**Staging model:** working dir → (`git add`) → staging → (`git commit`) → repo.
The middle step exists so one messy session becomes several clean commits.

**Use `switch`/`restore`, NOT `checkout`.** checkout did both jobs and people
destroyed work with it. Git split it deliberately.

## Git — .gitignore (security, not housekeeping)
Never commit: `.env` · `*.pem` · `*.key` · `id_rsa`/`id_ed25519` · `credentials`
Also ignore: `node_modules/` `vendor/` `dist/` `.next/` `*.log` `.DS_Store`
**Git history is permanent.** Deleting a secret in a later commit does NOT remove
it from history. Bots scan public repos for leaked cloud keys within minutes.
→ .gitignore goes in BEFORE the first real commit.

## Process — the branch loop (Day 3) ★
1. `git switch main && git pull`
2. `git switch -c type/description`
3. work → `git add` → `git diff --staged` → `git commit -m "..."`
4. `git switch main && git merge <branch>`
5. `git push`
6. `git branch -d <branch>` + `git push origin --delete <branch>`

## Gotchas / traps hit today
- `ssh -T` saying "does not provide shell access" is SUCCESS — read the "Hi user!" part
- Private key must be 600 or SSH refuses it entirely (same trap comes back with AWS .pem files)
- `.pub` goes to GitHub. If it starts with `-----BEGIN OPENSSH PRIVATE KEY-----`, wrong file.
- ssh-agent dies with the terminal → put the eval/ssh-add in ~/.bashrc
- SSH remote URL = colon after github.com, not slash
- `git branch -d` refuses unmerged branches on purpose — that's a safety net, not an obstacle

## Git — Commit discipline
| Command | What it does | When I'd use it |
|---|---|---|
| `git commit` | Opens vim for a full message | Any real commit — subject, BLANK LINE, why-body |
| `git commit -m "msg"` | One-line commit | Trivial changes only |
| `git commit --amend` | Rewrite the LAST commit | Fixing a typo in the message — local only, never after push |
| `git log --oneline` | Compact history | Constantly — finding SHAs |
| `git diff HEAD~1` | What the last commit changed | "What did I just ship?" |
| `git stash` / `stash pop` | Shelve WIP / bring it back | Urgent switch mid-change. Shelf, not storage. |

**Message format:** imperative subject ≤50 chars · blank line · body = WHY not what.
One commit = one logical change. If the message needs "and", split it.

## Git — Rollback ★ (the one I kept getting wrong)
| Command | What it does | When I'd use it |
|---|---|---|
| `git revert <sha>` | NEW commit that inverts the target | **Anything already pushed. Production rollback.** |
| `git reset --soft HEAD~1` | Undo commit, keep work STAGED | Bad message / committed too early — local only |
| `git reset HEAD~1` | Undo commit, keep work UNSTAGED | Reorganize into different commits — local only |
| `git reset --hard HEAD~1` | Undo commit AND delete the work | **DESTRUCTIVE, no prompt.** Abandoning an experiment |
| `git restore --staged file` | Unstage, keep edits | Cleaner than `git reset HEAD file` |
| `git reflog` | Every HEAD position, ~90 days | Rescue after a bad `--hard` |
| `git push --force-with-lease` | Force push, but refuse if remote moved | ONLY on my own unshared branch. Never plain `--force`. |

**THE RULE:** `reset` rewrites history · `revert` adds to it.
Rewriting is fine on commits only I have — destructive on anything anyone pulled.
**Pushed → revert. Always.**

**Three trees:** working dir → staging → repo. `reset` moves the pointer back;
`--soft` moves 1 tree, `--mixed` moves 2, `--hard` moves all 3 (deletes files).

**reflog caveat:** only recovers what was COMMITTED at some point. Unstaged work
destroyed by `--hard` is gone for good.

## Git — Tags
| Command | What it does | When I'd use it |
|---|---|---|
| `git tag -a v0.1.0 -m "msg"` | Annotated tag on HEAD | End of every phase; every release |
| `git tag -a v0.1.0 -m "msg" <sha>` | Tag a PAST commit | Retroactively marking a release |
| `git tag` / `git tag -l "v0.*"` | List / filter tags | "What versions exist?" |
| `git show v0.1.0` | Tag metadata + its commit | Verifying what a version actually contains |
| `git push origin v0.1.0` | Push ONE tag | **Required — plain `git push` does NOT send tags** |
| `git push --tags` | Push all tags | Bulk |
| `git tag -d v0.1.0` + `git push origin --delete v0.1.0` | Delete local + remote | Mistagged |

**Annotated (`-a`) vs lightweight:** annotated stores tagger/date/message as a real
object. Use annotated for anything that matters.
**Semver:** `vMAJOR.MINOR.PATCH` — breaking / feature / fix. `v0.x` = not stable yet.

## Process — the rollback decision (Day 4) ★
1. Is the commit pushed or on a shared branch?
   → YES: `git revert <sha>` and write WHY in the message. Stop here.
   → NO: continue.
2. Just the message/timing wrong? → `git reset --soft HEAD~1`, re-commit.
3. Want to reorganize the changes? → `git reset HEAD~1`, re-stage differently.
4. Genuinely abandoning the work? → `git reset --hard HEAD~1` (no undo prompt).
5. Regret step 4? → `git reflog` → `git reset --hard <sha>` (only if it was committed).

## Gotchas / traps hit today
- `git push` does NOT push tags — needs `push origin <tag>` or `--tags`
- `reset --hard` deletes working-directory files with NO confirmation
- reflog can't rescue work that was never committed
- Commit message needs a BLANK LINE after the subject or the whole thing
  becomes the subject
- `--amend` rewrites history too — safe locally, same danger as reset once pushed
- `git stash` is easy to forget about; commit on a branch if the work matters

## Commit Message Convention

    Subject line: imperative, capitalized, no period, ≤50 chars
    <blank line — required, Git parses on it>
    Body: explains WHY, not what. Wrapped ~72 chars.

- Imperative mood: "Add X", not "Added X" — matches Git's own generated
  messages ("Merge branch...", "Revert...").
- The diff already shows WHAT changed. Only the message can record WHY.
- One commit = one logical change. If the message needs "and", split it.
- `git commit` (no -m) opens vim for multi-line messages. `-m` is for trivial ones.

Why it's not cosmetic: at 2am, `git log` is the only account of what happened.
An interviewer opening my repo scrolls the commit history — it's the cheapest
available signal of whether I work like a professional.

## Rollback — revert vs reset

**The rule:** `reset` rewrites history · `revert` adds to it.
Rewriting is fine on commits only I have; destructive on anything anyone pulled.

| Situation | Use |
|---|---|
| Local only, never pushed | `reset` (any flag) |
| Pushed / shared branch | **`revert`, always** |
| Production broken, undo now | **`revert`** |

### The three trees (this makes reset obvious)
    WORKING DIR → STAGING (index) → REPOSITORY
reset moves the branch pointer back; the flag decides how many trees follow:

| Flag | Pointer | Staging | Working dir | Use for |
|---|---|---|---|---|
| `--soft` | moves | untouched | untouched | bad message / committed too early; work stays staged |
| `--mixed` (default) | moves | reset | untouched | reorganize into different commits |
| `--hard` | moves | reset | **reset** | **DESTRUCTIVE** — throw away an experiment |

### revert
- Creates a NEW commit that is the inverse of the target. Nothing is erased.
- `git revert <sha>` → always add a *reason* to the message; it's an incident record.
- Keeps the full story: added → broke → undone → why. That story is what a
  postmortem is built from (Constitution Part 13).
- Phase 3: `git revert` IS the production rollback — ArgoCD syncs the cluster
  to the repo, so reverting the commit reverts production.

### Never force-push a shared branch
`git push --force` after a reset destroys commits teammates already pulled.
If I must rewrite my OWN unshared branch: `git push --force-with-lease`
(refuses if the remote moved since my last fetch — `--force` has no such check).

### Safety net
`git reflog` records every HEAD position (~90 days) → recover after a bad
`reset --hard` with `git reset --hard <sha>`.
**Caveat:** only rescues things that were COMMITTED at some point. Work that was
only ever an unstaged edit is genuinely gone. Parachute, not a reason to jump.

## Tags

- A branch pointer moves; a **tag never moves** — a permanent name for one commit.
- **Annotated** (`-a -m`) stores tagger + date + message as a real object. Use this
  for anything meaningful. Lightweight tags are private bookmarks only.
- Semver `vMAJOR.MINOR.PATCH` — MAJOR=breaking, MINOR=feature, PATCH=fix.
  `v0.x.x` = not yet stable.
- **`git push` does NOT push tags.** Must do `git push origin <tag>` or `--tags`.
  Forgetting this is why a release doesn't show up on GitHub.
- Why it matters downstream: "roll back to the last good version" requires the
  version to have a NAME. P1 = release + matching ECR image tag. P3 = the image
  tag in the config repo is what ArgoCD deploys.

# Drill 01 — Disk Full

**Date:** 2026-07-19 · **Phase:** 0 · **Time to recover:** <your actual time>

## Symptoms
Application write failures: `No space left on device`. In production this
surfaces as 500s, a DB refusing writes, or a service that appears to hang.

## First place to look
`df -h` — and `df -i` for inodes. A full disk fakes every other symptom, so
it's ruled out in the first sixty seconds of any incident.

## Investigation
| Command | What it told me |
|---|---|
| `df -h` | Which filesystem hit 100% |
| `df -i` | Inodes — a disk can be "full" at 40% capacity |
| `du -sh /path/* \| sort -rh \| head -10` | Which directory is consuming it |

## Root cause
A single application log grew unbounded and consumed the filesystem. No
rotation configured. The cause is the missing constraint, not the full disk —
the full disk is the symptom.

## Fix
`sudo truncate -s 0 <file>` — empties in place, space returns immediately.

**Not `rm`:** if a process holds the file open, unlinking it does NOT release
the space until that process restarts. `df` stays full, `du` shows nothing.
Find these with `sudo lsof +L1`.

## Prevention
- `logrotate` with size limits, compression, retention
- Alarm at 80%, not 95% — you need runway
- Separate volume for `/var/log`
- Don't run production at DEBUG log level

## What I'd say in an interview
"Disk-full is my first check in any incident because it presents as everything
else. `df -h` then `df -i`, then `du` down the tree to find the offender.
Truncate rather than delete in case a process holds the handle, then fix the
rotation so it doesn't recur."

## Bash — Script anatomy
| Element | What it does | Notes |
|---|---|---|
| `#!/bin/bash` | Shebang — which interpreter runs this | `#!/bin/sh` is dash on Ubuntu; Alpine containers have NO bash |
| `chmod +x script.sh` | Make it executable | Every new script. Forget it → "permission denied" |
| `./script.sh` | Run it from the current dir | `.` is not in $PATH on purpose (security) |
| `# comment` | Comment | Header comment: what it does + usage line |

## Bash — Variables & quoting ★
| Syntax | What it does | When |
|---|---|---|
| `NAME="value"` | Assign — **no spaces around `=`** | `NAME = "x"` → "NAME: command not found" |
| `"$NAME"` | Read, expanded, no word-splitting | **DEFAULT — quote every expansion** |
| `'$NAME'` | Literal, no expansion | grep/awk patterns, strings containing `$` |
| `${NAME}_suffix` | Braces disambiguate | `$NAME_suffix` looks for a different variable |
| `${VAR:-default}` | Use VAR, or fallback if unset/empty | Optional args; container entrypoints |
| `$(command)` | Command substitution — insert its OUTPUT | Use this, not backticks |
| `$(( 5 - 1 ))` | Arithmetic | Different from `$( )` |

**THE QUOTING RULE:** unquoted expansions get split on whitespace.
`rm $FILE` where FILE="my report.txt" tries to remove TWO files.
`rm -rf $DIR` where DIR is empty is how production gets deleted.
→ **Quote every variable. Always.**

## Bash — Arguments
| Variable | Meaning |
|---|---|
| `$0` | Script name |
| `$1 $2 $3` | Positional arguments |
| `$#` | Argument count |
| `"$@"` | All args as SEPARATE words — use this |
| `$*` | All args as ONE string — rarely what you want |

Arguments + env vars are the automation-safe interface.
`read -p "..." VAR` is interactive only — it HANGS forever in CI, cron,
and container entrypoints. Never put `read` in anything a machine runs.

## Bash — Exit codes ★★ (the mechanism behind all of CI/CD)
| Syntax | Meaning |
|---|---|
| `$?` | Exit code of the LAST command — volatile, capture it immediately |
| `exit 0` | Success. **Exactly one value means success.** |
| `exit 1` | General failure (1–255 all mean failure) |
| `exit 2` | Convention: wrong usage / bad arguments |
| `A && B` | Run B only if A **succeeded** |
| `A \|\| B` | Run B only if A **failed** |
| `cmd 2>/dev/null` | Discard stderr |
| `cmd > f 2>&1` | Send stdout AND stderr to a file |
| `echo "err" >&2` | Write to stderr — where error messages belong |

**Zero is success; non-zero is failure.** One way to succeed, many to fail.
**`grep` exits 1 when it finds nothing** — that's an answer, not an error.
**Capture immediately:** `cmd; STATUS=$?` — `$?` is overwritten by the next command.
**Always `exit` explicitly.** Without it a script returns its LAST command's code,
usually a successful `echo` — so a broken script reports success.

**Where this shows up later:**
- GitHub Actions: a step fails when its command returns non-zero (P1)
- Dockerfile: every `RUN` must exit 0 or the build stops (W3)
- Docker HEALTHCHECK / K8s liveness probe: non-zero → unhealthy → restarted (P3)
- `terraform plan -detailed-exitcode` gates the pipeline (P2)
→ Five technologies, one integer.

## Bash — Streams
stdin=0 · stdout=1 · stderr=2. Separate on purpose: pipe real output while
errors still reach a human. `>&2` for error messages, so log-based alerting
(P3) can distinguish normal operation from problems.

## Gotchas / traps hit today
- `NAME = "x"` fails — no spaces around `=`
- Unquoted `$VAR` splits on whitespace; empty unquoted vars vanish entirely
- `$?` is overwritten by the very next command, including `echo`
- No explicit `exit` → script returns the last command's code (often a false success)
- `$NAME_suffix` ≠ `${NAME}_suffix`
- Backticks work but don't nest — use `$( )`
- `#!/bin/sh` is not bash; Alpine images have no bash at all
- `awk '{print $1}'` needs SINGLE quotes or bash eats the `$1` first