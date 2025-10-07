# ============================================================
# LINUX
# ============================================================

# ------------------------------------------------------------
# Process Management
# ------------------------------------------------------------
ps aux | grep <process>
top
htop
pgrep <name>
pkill <name>

# ------------------------------------------------------------
# File & Permissions
# ------------------------------------------------------------
ls -l
chmod 755 file
chown user:group file
stat file

# ------------------------------------------------------------
# Network & Sockets
# ------------------------------------------------------------
netstat -tulpn
ss -tulpn
tcpdump -i eth0
nmap -sV -p- target

# ------------------------------------------------------------
# Kernel & Exploitation
# ------------------------------------------------------------
dmesg | tail
/boot/config-$(uname -r)
sysctl -a
uname -a
checksec --file=/bin/bash

# ------------------------------------------------------------
# Automation & Scripting
# ------------------------------------------------------------
awk, sed, grep, xargs
find / -perm -4000 -type f 2>/dev/null
strace -p <pid>
ltrace -p <pid>


# ============================================================
# PYTHON
# ============================================================

# ------------------------------------------------------------
# Useful Modules for Security / Exploit Dev
# ------------------------------------------------------------
import ctypes
import mmap
import socket
import struct
import hashlib
import subprocess
import threading

# ------------------------------------------------------------
# Binary / Memory Manipulation
# ------------------------------------------------------------
ctypes.memmove
mmap.mmap
struct.pack/unpack

# ------------------------------------------------------------
# Networking
# ------------------------------------------------------------
socket.socket
ssl.wrap_socket
asyncio for concurrent connections

# ------------------------------------------------------------
# Fuzzing & Exploit Dev
# ------------------------------------------------------------
pwntools (pwntools) for CTF / exploitation
angr for binary analysis
pyelftools for ELF parsing
capstone for disassembly


# ============================================================
# JAVASCRIPT
# ============================================================

# ------------------------------------------------------------
# Node.js Useful Modules
# ------------------------------------------------------------
fs, net, child_process, crypto
vm module for sandboxing
buffer for binary data

# ------------------------------------------------------------
# Exploitation / Security Tips
# ------------------------------------------------------------
prototype pollution
deserialization attacks (e.g., using serialize-javascript)
Buffer overflows with native bindings
sandbox escape via vm / process


# ============================================================
# GO (GOLANG)
# ============================================================

# ------------------------------------------------------------
# Standard Library Useful for Exploit Dev
# ------------------------------------------------------------
net, os, io, syscall, unsafe, reflect
encoding/binary
context for concurrency

# ------------------------------------------------------------
# Binary / Memory Manipulation
# ------------------------------------------------------------
unsafe.Pointer
syscall.Syscall
reflect.Value to manipulate private fields
go:linkname for internal access

# ------------------------------------------------------------
# Networking / Automation
# ------------------------------------------------------------
net.Dial, net.Listen
http.Client with custom TLS config
goroutines for concurrent scanning / fuzzing


# ============================================================
# RUST
# ============================================================

# ------------------------------------------------------------
# Standard Library Useful for Security
# ------------------------------------------------------------
std::fs, std::io, std::net, std::process, std::thread
std::mem for unsafe memory operations
std::ptr

# ------------------------------------------------------------
# Unsafe / Exploit Techniques
# ------------------------------------------------------------
unsafe { ... } blocks
std::ptr::read_volatile, write_volatile
std::mem::transmute for type punning
inline assembly via asm! macro

# ------------------------------------------------------------
# Binary / Networking
# ------------------------------------------------------------
std::net::TcpStream / TcpListener
tokio / async-std for async network programming
goblin crate for parsing ELF / PE binaries


# ============================================================
# PENTEST / 0-DAY RESEARCH TOOLS
# ============================================================

# ------------------------------------------------------------
# Recon & Footprinting
# ------------------------------------------------------------
Amass (subdomain enumeration)
Subfinder
Assetfinder
Shodan CLI
Masscan for fast port scanning

# ------------------------------------------------------------
# Fuzzing / Exploit Development
# ------------------------------------------------------------
AFL / AFLplusplus
libFuzzer
honggfuzz
boofuzz (network fuzzing)
Radare2 / Cutter (binary analysis)
Ghidra for reverse engineering
angr for symbolic execution

# ------------------------------------------------------------
# Memory / Kernel
# ------------------------------------------------------------
Volatility / Rekall for memory analysis
Crashme / syzkaller (kernel fuzzing)
KASAN / KUBSAN (kernel sanitizers)

# ------------------------------------------------------------
# Binary / Web
# ------------------------------------------------------------
Burp Suite (with extensions)
OWASP ZAP
wfuzz / ffuf for web fuzzing
nuclei for template-based scanning

# ------------------------------------------------------------
# Less Known / Highly Useful
# ------------------------------------------------------------
Evan's Payloads Repo (exotic payloads)
one_gadget (glibc exploitation)
pwntools exploit templates
pwncat / pwnlib (post-exploitation frameworks)
ROPgadget / Ropper for gadget search
GDB Python scripting for automation
IDA Pro / Ghidra scripting for automation