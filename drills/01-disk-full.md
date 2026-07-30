# Drill 01 — Disk Full


**Date:** <today> · **Phase:** 0 · **Time to recover:** <your actual time>


## Symptoms
Write failures: `No space left on device`. In production: 500s, DB refusing
writes, or a service that appears to hang.


## First place to look
`df -h`, then `df -i` for inodes. A full disk fakes every other symptom, so
it's ruled out in the first sixty seconds.


## Investigation
| Command | What it told me |
|---|---|
| `df -h` | Which filesystem hit 100% |
| `df -i` | Inodes — a disk can be "full" at 40% capacity |
| `du -sh /path/* \| sort -rh \| head` | Which directory is consuming it |


## Root cause
A log grew unbounded; no rotation. The cause is the missing constraint, not the
full disk — that's the symptom.


## Fix
`sudo truncate -s 0 <file>` — empties in place, space returns immediately.
Not `rm`: a process holding the file open keeps the space until it restarts
(`df` full, `du` empty). Find those with `sudo lsof +L1`.


## Prevention
- logrotate with size limits + retention
- alarm at 80%, not 95%
- separate volume for /var/log
- no DEBUG logging in production


## What I'd say in an interview
"Disk-full is my first check because it presents as everything else. df -h,
then df -i, then du down the tree. Truncate not delete in case a process holds
the handle, then fix the rotation so it can't recur."

