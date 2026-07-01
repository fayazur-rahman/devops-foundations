# devops-foundations

Personal repository tracking Phase 0 of a structured DevOps learning roadmap.
Demonstrates Linux fluency, Git workflow discipline, Bash scripting, and Docker
fundamentals — the operational foundation for everything that comes after.

---

## What's here

| Directory | Contents |
|---|---|
| `linux/` | Command reference and log-reading notes |
| `git/` | Branch workflow, commit conventions, revert/reset decision notes |
| `bash/` | Scripts — monitoring, control flow (populated in Week 2) |
| `docker/` | Dockerfiles, compose files, build notes (populated in Week 3) |

---

## Phase 0 Exit Criteria

Tracking against the roadmap's definition of "phase complete":

- [ ] Shell-fluent — navigate, read logs, diagnose permissions from memory
- [ ] Bash loop + conditional — a real monitoring script
- [ ] Multi-stage Docker image — built and verified smaller than single-stage
- [ ] Billing alarm active on AWS
- [ ] This repo: public, structured, documented

---

## Key Concepts Covered

**Linux:** filesystem layout, permissions (chmod/chown), process management
(ps/kill/systemctl), disk/memory/network diagnostics, log reading and piping.

**Git:** SSH authentication, branch workflow (feature branches, merge, delete),
commit message convention, revert vs reset, annotated tags.

**Failure drills:** disk full, permission denied, service won't start — each
worked through the incident method: symptoms → logs → investigation →
root cause → fix → prevention.

---


## THE SPIRAL MAP
 
| Phase | Weeks | New layer | Reuses |
|---|---|---|---|
| 0 — Tools | 1–3 | Linux · Git · Docker · Bash · env | — |
| 1 — First deploy | 4–7 | Containers · first CI/CD · first cloud deploy | P0 |
| 2 — IaC | 8–12 | Terraform · Redis · monitoring · logging · multi-tier | P0–1 |
| 3 — Orchestration | 13–18 | Kubernetes (EKS) · microservices · broker · Prometheus/Grafana · GitOps | P0–2 |
| 4 — Scale & secure | 19–24 | GCP · DevSecOps · autoscaling · CDN · Next.js | P0–3 |
 
---

## How to use this

The notes here are a personal reference, not a tutorial. Each command comes
from hands-on practice, not copying — so this grows as the work progresses.

