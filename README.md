# HRL Hyper OS

A hybrid operating system combining an immutable Linux base (`configuration.nix`), macOS Aqua/Sonoma desktop UX (`shell.css` + live HTML5 window manager), and a Feudal Hierarchical Reinforcement Learning (`hrld.py`) OS daemon.

## Quick Start (macOS / Linux Live Desktop)

```bash
python3 hrld.py
```

Opens `http://127.0.0.1:8765` with:
- **macOS Top Menu Bar & Translucent Dock**
- **⌘K Spotlight** connected to the Feudal HRL Manager (`manager_select` -> `worker_exec`)
- **Draggable & Resizable Windows** (POSIX Terminal, Finder File Browser, Persistent Subgoal Q-Table)
- **Live RL Feedback**: Train subgoal routing weights with `👍 / 👎` persisted to `q_table.json`

## Self-Check

```bash
python3 hrld.py --check
```

## Build Bootable Linux ISO (NixOS)

```bash
nixos-generate -f iso -c configuration.nix
```
