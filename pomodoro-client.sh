#!/usr/bin/env bash
#Simple client for pomodoro-daemon.sh
readonly API=/dev/shm/pomodoro
readonly LOCK=/dev/shm/pomodoro.lock
readonly FIFO=/dev/shm/pomodoro.app

call() {

    while true;do
        {
            flock -w 5 -x 7 || { echo "Couldn't acquire the lock" >&2; continue; }
            echo $1 > $API 
            break
        } 7>$LOCK
    done
    #wait for response
    sleep 0.1
    echo $(<$API)
}

usage() { echo "Unknown option: try start,pause,stop,status or quit to close the daemon"; }

com() {
    [[ ! -p $FIFO ]] && { echo "Daemon not running"; return; }
    call $1
    call status
}

case $1 in
    start|pause|stop|status|quit)  com $1
        ;;
    *                           ) usage
        ;;
esac

