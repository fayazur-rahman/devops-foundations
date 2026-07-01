# Linux Commands Reference
*Personal cheat sheet — started 2026-06-29*

---

## Navigation
| Command | What it does |
|---|---|
| `pwd` | print current directory |
| `ls -la` | list all files with permissions + hidden |
| `cd ~` | go home |
| `cd -` | go back to previous directory |
| `find /path -name "*.log" -mtime -7` | find .log files modified in last 7 days |
| `mkdir -p a/b/c` | create full directory path |
| `cp -r src/ dst/` | recursive copy |

## Log Reading
| Command | What it does |
|---|---|
| `tail -n 200 file` | last 200 lines |
| `tail -f file` | follow a file in real-time |
| `grep -i "error" file` | case-insensitive search |
| `grep -n "text" file` | show line numbers |
| `grep -r "text" /dir/` | search all files in directory |
| `journalctl --no-pager -n 200` | last 200 journal lines (WSL2/modern Ubuntu) |
| `wc -l file` | count lines |

## Power Pipelines
```bash
# Errors in last 200 lines
tail -n 200 /var/log/syslog | grep -i "error" | wc -l

# Most common log entries
cat /var/log/syslog | sort | uniq -c | sort -rn | head -20
```

## WSL2 Note
`/var/log/syslog` may not exist → use `journalctl --no-pager` instead.

## Permissions
| Command | What it does |
|---|---|
| `ls -la` | show permissions, owner, group for all files |
| `chmod 644 file` | owner rw, everyone r |
| `chmod 755 dir/` | owner rwx, everyone rx (dirs + executables) |
| `chmod 600 file` | owner rw only (secrets, SSH keys) |
| `chmod -R 755 dir/` | apply recursively |
| `chown user:group file` | change owner and group |
| `chown -R user:group dir/` | recursive ownership change |
| `whoami` | who am I right now? |
| `id` | my user + all my groups |

## Processes
| Command | What it does |
|---|---|
| `ps aux` | snapshot of all running processes |
| `ps aux \| grep nginx` | find nginx processes |
| `top` / `htop` | live resource view |
| `kill <PID>` | polite stop (SIGTERM) |
| `kill -9 <PID>` | force kill (SIGKILL) |
| `pkill nginx` | kill by name |

## Disk / Memory / Network
| Command | What it does |
|---|---|
| `df -h` | disk space, human-readable |
| `du -sh /path` | size of a specific path |
| `free -h` | memory usage |
| `ss -tulpn` | what's listening on which port |
| `ip addr` | network interfaces + IPs |
| `curl -I http://localhost` | HTTP health check (headers only) |

## Service Management (systemctl + journalctl)
| Command | What it does |
|---|---|
| `systemctl status nginx` | is it running? recent errors? |
| `systemctl start nginx` | start it |
| `systemctl stop nginx` | stop it |
| `systemctl restart nginx` | stop + start |
| `systemctl enable nginx` | start at boot |
| `journalctl -u nginx -n 50` | last 50 log lines for nginx |
| `journalctl -u nginx -f` | follow nginx logs live |
| `journalctl -u nginx --since "10 minutes ago"` | recent logs |
| `sudo nginx -t` | test nginx config for syntax errors |

## The Service Debug Loop
```
systemctl status <service>   → is it running? read the bottom lines
journalctl -u <service> -n 100  → find the error
fix the problem
systemctl restart <service>
systemctl status <service>   → confirm running
```
