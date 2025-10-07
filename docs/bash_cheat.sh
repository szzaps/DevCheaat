#!/bin/bash
# ============================================================
# Bash & Shell Programming
# ============================================================


# ============================================================
# PROCESS MANAGEMENT & JOB CONTROL
# ============================================================

# Process substitution
diff <(curl -s http://api1.example.com/data) <(curl -s http://api2.example.com/data)


# ------------------------------------------------------------
# Coprocesses for bidirectional communication
# ------------------------------------------------------------
coproc API_PROC { 
    while read -r cmd; do
        case $cmd in
            get_status) echo "RUNNING" ;;
            get_stats) jq '.metrics' /tmp/data.json ;;
        esac
    done
}


# ============================================================
# SIGNAL HANDLING
# ============================================================
declare -A SIGNAL_HANDLERS

trap_with_arg() {
    func="$1"; shift
    for sig; do
        trap "$func $sig" "$sig"
    done
}

signal_handler() {
    local sig=$1
    echo "[$(date)] Received $sig" >> /var/log/script_signals.log
    case $sig in
        SIGTERM) graceful_shutdown ;;
        SIGUSR1) rotate_logs ;;
        SIGUSR2) reload_config ;;
    esac
}

trap_with_arg signal_handler SIGTERM SIGINT SIGUSR1 SIGUSR2


# ============================================================
# ARRAYS & ASSOCIATIVE ARRAYS
# ============================================================
declare -A MATRIX
MATRIX[0,0]=1; MATRIX[0,1]=2; MATRIX[0,2]=3
MATRIX[1,0]=4; MATRIX[1,1]=5; MATRIX[1,2]=6

matrix_multiply() {
    local -n A=$1 B=$2 C=$3
    local rows=$4 cols=$5
    
    for ((i=0; i<rows; i++)); do
        for ((j=0; j<cols; j++)); do
            C[$i,$j]=0
            for ((k=0; k<cols; k++)); do
                C[$i,$j]=$(( ${C[$i,$j]} + ${A[$i,$k]} * ${B[$k,$j]} ))
            done
        done
    done
}


# ============================================================
# NETWORK & SOCKET PROGRAMMING
# ============================================================
exec 3<>/dev/tcp/google.com/80
printf "GET / HTTP/1.1\r\nHost: google.com\r\nConnection: close\r\n\r\n" >&3
cat <&3
exec 3>&-


# ============================================================
# PERFORMANCE MONITORING
# ============================================================
get_system_metrics() {
    local interval=${1:-1}
    paste <(cat /proc/stat | grep "^cpu[0-9]") \
          <(sleep $interval; cat /proc/stat | grep "^cpu[0-9]") | \
    awk '{idle2=$5; total2=0; for(i=2;i<=NF;i++) total2+=$i; print $1, (1-($5-idle2)/(total2-total1))*100}'
}


# ============================================================
# SECURITY & CRYPTOGRAPHY
# ============================================================
generate_key() {
    local length=$1
    head -c $length /dev/urandom | base64 | head -c $length
}

hash_password() {
    local password=$1
    local salt=$(generate_key 16)
    echo -n "$password$salt" | sha256sum | cut -d' ' -f1
}


# ============================================================
# DEBUGGING
# ============================================================
set -euo pipefail
trap 'echo "Error at line $LINENO: $BASH_COMMAND"; exit 1' ERR

debug::stack_trace() {
    local frame=0
    while caller $frame; do
        ((frame++))
    done
}


# ============================================================
# TEXT PROCESSING
# ============================================================
parse_logs() {
    awk '
    BEGIN { 
        FS=" "; 
        errors=0; warnings=0 
    }
    /ERROR/ { 
        errors++; 
        print "[" strftime() "] Critical: " $0 > "/dev/stderr"
    }
    /WARNING/ { warnings++ }
    END { 
        print "Summary - Errors: " errors ", Warnings: " warnings 
    }
    ' /var/log/app.log
}


# ============================================================
# PROCESS ORCHESTRATION
# ============================================================
declare -i CONCURRENT_JOBS=4
declare -i CURRENT_JOBS=0
declare -a JOB_PIDS=()

acquire_slot() {
    while (( CURRENT_JOBS >= CONCURRENT_JOBS )); do
        wait -n 2>/dev/null && CURRENT_JOBS-=1
    done
    ((CURRENT_JOBS++))
}

parallel_process() {
    local item=$1
    acquire_slot
    (
        process_item "$item"
        ((CURRENT_JOBS--))
    ) &
    JOB_PIDS+=($!)
}