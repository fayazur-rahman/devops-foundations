# devops-foundations


Phase 0 of a six-month roadmap to becoming an employable Junior DevOps Engineer.
This repo holds the toolbelt: Linux fluency, Bash, Docker, and a professional
Git workflow — plus write-ups of failures I broke on purpose and recovered.


## Why this repo exists
Every later phase sits on two assumptions: that I can read a machine I've never
seen, and that I can control a repository safely. This is where both were built.
The notes are written for my future self — each command recorded with *when I'd
reach for it*, not just what it does.


## Structure


| Folder | Contents |
|---|---|
| `linux/` | Command reference: navigation, logs, permissions, processes, systemd, triage |
| `bash/` | Scripts — including `monitor.sh`, a disk/memory/service health checker |
| `docker/` | Dockerfiles, Compose notes, volume/network notes |
| `git/` | Workflow notes: SSH auth, branching, commit convention, rollback rules |
| `drills/` | Failure drills — symptoms, investigation, root cause, fix, prevention |


## Failure drills


Real DevOps is recovery, not deployment. Each drill follows the same method:
**symptoms → logs → investigation → root cause → fix → prevention.**


| Drill | Failure | Write-up |
|---|---|---|
| 01 | Disk full | [`drills/01-disk-full.md`](drills/01-disk-full.md) |
| 02 | Permission denied | [`drills/02-permission-denied.md`](drills/02-permission-denied.md) |
| 03 | Service won't start | [`drills/03-service-wont-start.md`](drills/03-service-wont-start.md) |


## Phase 0 exit criteria


- [ ] Shell-fluent — navigate, read, and filter logs without reference
- [ ] Bash script with a loop and a conditional
- [ ] Multi-stage Docker image, meaningfully smaller than single-stage
- [ ] AWS billing alarm + monthly budget active
- [ ] This repo public with a real README


## Environment


Native Ubuntu 24 (dual-boot alongside Windows).


## Roadmap


Phase 0 Reboot · Phase 1 First deploy (EC2, RDS, CI/CD) · Phase 2 Laravel on
Terraform · Phase 3 Microservices on Kubernetes · Phase 4 Scale, secure,
multi-cloud · Phase 5 Get hired.

