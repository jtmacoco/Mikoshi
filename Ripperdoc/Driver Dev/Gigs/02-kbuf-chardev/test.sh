#!/usr/bin/env bash
# Test script for 02-kbuf-chardev. Run inside the VM: ./test.sh
set -u
cd "$(dirname "$0")"

# Copy all output to test_output.txt so the tutor can read it.
exec > >(tee test_output.txt) 2>&1
echo "run: $(date '+%F %T')  kernel: $(uname -r)  host: $(uname -n)"
echo "kbuf.c sha256: $(sha256sum kbuf.c | cut -d' ' -f1)"

MOD=kbuf
KO=./$MOD.ko
DEV=/dev/$MOD
CLS=/sys/class/$MOD
pass=0
fail=0

ok()  { echo "PASS: $*"; pass=$((pass + 1)); }
# bad <description> <expected> <got>: every failure shows both sides.
bad() {
	echo "FAIL: $1"
	fail=$((fail + 1))
	echo "      expected:"
	sed 's/^/        /' <<<"$2"
	echo "      got:"
	if [ -n "${3:-}" ]; then sed 's/^/        /' <<<"$3"; else echo "        (nothing)"; fi
}
# check <description> <expected> <got>: pass if they are equal.
check() { [ "$2" = "$3" ] && ok "$1" || bad "$1" "$2" "$3"; }

# Write a marker into the kernel log so we only inspect messages after it.
# RUN makes markers unique per run, so earlier runs' messages are ignored.
RUN=$$.$(date +%s)
mark() { echo "$MOD-test: $RUN $1" | sudo tee /dev/kmsg >/dev/null; }
log_since() { sudo dmesg | sed -n "/$MOD-test: $RUN $1\$/,\$p"; }
# What the module logged since a marker, minus timestamps and test markers.
mod_log() { log_since "$1" | grep -v "$MOD-test: " | sed 's/^\[[^]]*\] //'; }

loaded() { lsmod | grep -q "^$MOD "; }
major() { awk -v m=$MOD '$2 == m { print $1 }' /proc/devices; }
settle() { udevadm settle 2>/dev/null || sleep 1; }
# put <string>: write with the shell's '>' (O_TRUNC). get: read it all back.
put() { sudo sh -c 'printf "%s" "$1" > "$2"' sh "$1" "$DEV" 2>&1; }
get() { sudo cat "$DEV" 2>&1; }
load() { sudo insmod $KO "$@" 2>&1 && settle; }
unload() { sudo rmmod $MOD 2>&1 && settle; }
# Nothing may remain after an unload or a failed load.
check_gone() {
	check "$1: no $DEV" "absent" "$([ -e $DEV ] && ls -l $DEV || echo absent)"
	check "$1: no $MOD in /proc/devices" "" "$(grep " $MOD\$" /proc/devices)"
	check "$1: no $CLS" "absent" "$([ -e $CLS ] && ls -d $CLS || echo absent)"
}

sudo rmmod $MOD 2>/dev/null

echo "== build"
make -s || { echo "build failed"; exit 1; }

echo "== modinfo"
params=$(modinfo -p $KO 2>&1)
grep -qE '^size:[^ ]' <<<"$params" && ok "size param has a description" ||
	bad "size param has a description" "size:<description> (int)" "$params"
v=$(modinfo -F license $KO)
[ -n "$v" ] && ok "MODULE_LICENSE set" || bad "MODULE_LICENSE set" "a valid license" "$v"

echo "== load (default size)"
mark t1
out=$(load) || bad "insmod with defaults" "insmod succeeds" "$out"
if ! loaded; then
	echo "module did not load; stopping here"
	echo
	echo "== kernel log for this run"
	mod_log t1
	echo
	echo "Passed: $pass  Failed: $((fail + 1))"
	exit 1
fi
m=$(major)
[ -n "$m" ] && ok "$MOD listed in /proc/devices (major $m)" ||
	bad "$MOD listed in /proc/devices" "<major> $MOD" "$(cat /proc/devices)"
check "load message" "kbuf: registered $m:0 (size=4096)" "$(mod_log t1)"
[ -c $DEV ] && ok "$DEV is a character device" ||
	bad "$DEV is a character device" "crw------- ... $DEV" "$(ls -l $DEV 2>&1)"
check "$DEV major:minor matches /proc/devices" "$m:0" \
	"$( [ -c $DEV ] && printf '%d:%d' 0x$(stat -c %t $DEV) 0x$(stat -c %T $DEV))"
check "$CLS/$MOD/dev" "$m:0" "$(cat $CLS/$MOD/dev 2>&1)"
check "sysfs size param" "4096" "$(cat /sys/module/$MOD/parameters/size 2>&1)"

echo "== read and write"
check "fresh device reads empty" "" "$(get)"
out=$(put hello) || bad "write 'hello'" "write succeeds" "$out"
check "read back 'hello'" "hello" "$(get)"
out=$(put ab) || bad "write 'ab'" "write succeeds" "$out"
check "shorter write with '>' replaces data (O_TRUNC)" "ab" "$(get)"
out=$(sudo sh -c '{ printf ab; printf cd; } > "$1"' sh $DEV 2>&1) ||
	bad "two writes on one open file" "writes succeed" "$out"
check "second write on same fd continues at *ppos" "abcd" "$(get)"
check "1-byte reads (dd bs=1) return everything" "abcd" "$(sudo dd if=$DEV bs=1 status=none 2>&1)"
check "a second read of the same data still works" "abcd" "$(get)"

echo "== unload refused while open"
sudo sh -c 'exec 3<"$1"; sleep 3' sh $DEV &
holder=$!
sleep 1
rc=$(cat /sys/module/$MOD/refcnt 2>&1)
if [ "$rc" = 0 ]; then
	# Unloading now would leave a dangling file pointing into freed module
	# code, so don't even try.
	bad "module refcount rises while $DEV is open" "refcnt >= 1 (hint: .owner)" "refcnt $rc"
else
	ok "module refcount rises while $DEV is open (refcnt $rc)"
	out=$(sudo rmmod $MOD 2>&1) &&
		bad "rmmod refused while open" "rmmod: ERROR: Module kbuf is in use" "rmmod succeeded" ||
		ok "rmmod refused while open"
fi
wait $holder

echo "== unload"
mark t2
out=$(unload) || bad "rmmod" "rmmod succeeds" "$out"
check "unload message" "kbuf: unregistered" "$(mod_log t2)"
check_gone "after unload"

echo "== reload (did unload clean up?)"
mark t3
out=$(load) || bad "insmod a second time" "insmod succeeds" "$out"
check "reloaded device reads empty" "" "$(get)"
unload >/dev/null

echo "== small buffer (size=16)"
mark t4
out=$(load size=16) || bad "insmod size=16" "insmod succeeds" "$out"
out=$(printf '%020d' 0 | sudo dd of=$DEV bs=20 count=1 status=none 2>&1) &&
	bad "writing 20 bytes into a 16-byte buffer fails" "dd: ... No space left on device" "dd succeeded" ||
	{ grep -q 'No space left' <<<"$out" && ok "writing past the end gives ENOSPC" ||
		bad "writing past the end gives ENOSPC" "dd: ... No space left on device" "$out"; }
check "buffer holds the first 16 bytes" "$(printf '%016d' 0)" "$(get)"
unload >/dev/null

echo "== invalid size must fail the load and leave nothing behind"
for s in 0 65537 -1; do
	mark "t5$s"
	if sudo insmod $KO size=$s 2>/dev/null; then
		bad "insmod size=$s fails" "insmod fails with an error" "insmod succeeded"
		unload >/dev/null
	else
		ok "insmod size=$s fails"
	fi
	settle
	grep -q "^$MOD: " <<<"$(mod_log "t5$s")" && ok "size=$s: error logged" ||
		bad "size=$s: error logged" "a '$MOD: ...' error line" "$(mod_log "t5$s")"
	check_gone "size=$s"
done

echo
echo "== kernel log for this run"
log_since t1 | sed 's/^\[[^]]*\] //'

echo
echo "Passed: $pass  Failed: $fail"
[ "$fail" -eq 0 ]
