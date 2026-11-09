#!/usr/bin/env bash
# Test script for 03-kbank-multi. Run inside the VM: ./test.sh
set -u
cd "$(dirname "$0")"

# Copy all output to test_output.txt so the tutor can read it.
exec > >(tee test_output.txt) 2>&1
echo "run: $(date '+%F %T')  kernel: $(uname -r)  host: $(uname -n)"
echo "kbank.c sha256: $(sha256sum kbank.c | cut -d' ' -f1)"

MOD=kbank
KO=./$MOD.ko
CLS=/sys/class/$MOD
pass=0
fail=0

ok()  { echo "PASS: $*"; pass=$((pass + 1)); }
skip() { echo "SKIP: $*"; }
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

# Kernel log markers, so we only inspect messages from this run.
RUN=$$.$(date +%s)
mark() { echo "$MOD-test: $RUN $1" | sudo tee /dev/kmsg >/dev/null; }
log_since() { sudo dmesg | sed -n "/$MOD-test: $RUN $1\$/,\$p"; }
# What the module logged since a marker, minus timestamps, test markers, and
# the kernel's one-time taint notices (which also carry the "kbank: " prefix).
mod_log() {
	log_since "$1" | grep -v -e "$MOD-test: " -e "taints kernel" \
		-e "module verification failed" | sed 's/^\[[^]]*\] //'
}

loaded() { lsmod | grep -q "^$MOD "; }
major() { awk -v m=$MOD '$2 == m { print $1 }' /proc/devices; }
settle() { udevadm settle 2>/dev/null || sleep 1; }
dev() { echo "/dev/$MOD$1"; }
# put <bank> <string>: write with '>' (O_WRONLY|O_TRUNC). bash's printf
# retries short writes, so a write that doesn't fit ends with ENOSPC.
put() { sudo bash -c 'printf "%s" "$1" > "$2"' bash "$2" "$(dev $1)" 2>&1; }
# append <bank> <string>: write with '>>' (O_WRONLY|O_APPEND, no O_TRUNC).
append() { sudo bash -c 'printf "%s" "$1" >> "$2"' bash "$2" "$(dev $1)" 2>&1; }
# overwrite <bank> <string>: open read-write with '<>' (O_RDWR, no O_TRUNC,
# no O_APPEND) and write at position 0.
overwrite() { sudo bash -c 'exec 3<>"$2" && printf "%s" "$1" >&3' bash "$2" "$(dev $1)" 2>&1; }
get() { sudo cat "$(dev $1)" 2>&1; }
load() { sudo insmod $KO "$@" 2>&1 && settle; }
unload() { sudo rmmod $MOD 2>&1 && settle; }
# ok_write <desc> <cmd...>: the write must succeed.
ok_write() {
	local d=$1 out
	shift
	out=$("$@") && ok "$d" || bad "$d" "write succeeds" "$out"
}
# full_write <desc> <cmd...>: the write must fail with "No space left".
full_write() {
	local d=$1 out
	shift
	if out=$("$@"); then
		bad "$d" "write fails: No space left on device" "write succeeded"
	elif grep -q 'No space left' <<<"$out"; then
		ok "$d"
	else
		bad "$d" "write fails: No space left on device" "$out"
	fi
}
# Nothing may remain after an unload or a failed load.
check_gone() {
	check "$1: no /dev/$MOD*" "" "$(ls /dev | grep "^$MOD")"
	check "$1: no $MOD in /proc/devices" "" "$(grep " $MOD\$" /proc/devices)"
	check "$1: no $CLS" "absent" "$([ -e $CLS ] && ls -d $CLS || echo absent)"
}
# load_fails <desc> <errno text> <params...>: insmod must fail with that error,
# log a kbank: line, and leave nothing behind.
load_fails() {
	local d=$1 want=$2 out
	shift 2
	mark "$d"
	if out=$(sudo insmod $KO "$@" 2>&1); then
		bad "$d: insmod fails" "insmod fails: $want" "insmod succeeded"
		unload >/dev/null
	elif grep -q "$want" <<<"$out"; then
		ok "$d: insmod fails with '$want'"
	else
		bad "$d: insmod fails" "insmod fails: $want" "$out"
	fi
	settle
	grep -q "^$MOD: " <<<"$(mod_log "$d")" && ok "$d: error logged" ||
		bad "$d: error logged" "a '$MOD: ...' line" "$(mod_log "$d")"
	check_gone "$d"
}

sudo rmmod $MOD 2>/dev/null

echo "== build"
make -s || { echo "build failed"; exit 1; }

echo "== checkpatch"
cpl=""
for c in /lib/modules/$(uname -r)/build/scripts/checkpatch.pl \
	 /usr/src/linux-headers-$(uname -r)/scripts/checkpatch.pl \
	 /usr/src/linux-headers-*/scripts/checkpatch.pl; do
	[ -f "$c" ] && { cpl=$c; break; }
done
if [ -z "$cpl" ]; then
	skip "checkpatch.pl not found in the VM; run it on the host (see README)"
else
	cp_out=$(perl "$cpl" --no-tree -f $MOD.c 2>&1)
	cp_total=$(grep '^total:' <<<"$cp_out" | sed 's/, [0-9]* lines checked//')
	if [ "$cp_total" = "total: 0 errors, 0 warnings" ]; then
		ok "checkpatch clean"
	else
		bad "checkpatch clean" "total: 0 errors, 0 warnings" \
			"$(grep -E '^(ERROR|WARNING|#|total)' <<<"$cp_out")"
	fi
fi

echo "== modinfo"
params=$(modinfo -p $KO 2>&1)
for p in nbanks size fail_at; do
	grep -qE "^$p:[^ ]" <<<"$params" && ok "$p param has a description" ||
		bad "$p param has a description" "$p:<description> (int)" "$params"
done
v=$(modinfo -F license $KO)
[ -n "$v" ] && ok "MODULE_LICENSE set" || bad "MODULE_LICENSE set" "a valid license" "$v"

echo "== load (defaults: 4 banks)"
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
check "load message" "kbank: registered 4 devices, major $m (size=4096)" "$(mod_log t1)"
for i in 0 1 2 3; do
	d=$(dev $i)
	check "$d is $m:$i" "$m:$i" \
		"$( [ -c $d ] && printf '%d:%d' 0x$(stat -c %t $d) 0x$(stat -c %T $d) || echo "missing")"
	check "$CLS/$MOD$i/dev" "$m:$i" "$(cat $CLS/$MOD$i/dev 2>&1)"
done
check "no $(dev 4)" "absent" "$([ -e $(dev 4) ] && echo present || echo absent)"
check "sysfs nbanks param" "4" "$(cat /sys/module/$MOD/parameters/nbanks 2>&1)"

echo "== banks are separate"
ok_write "write 'zero' to bank 0" put 0 zero
ok_write "write 'one' to bank 1" put 1 one
check "bank 0 has its own data" "zero" "$(get 0)"
check "bank 1 has its own data" "one" "$(get 1)"
check "bank 2 is still empty" "" "$(get 2)"
check "bank 3 is still empty" "" "$(get 3)"

echo "== read and write (02 rules, on bank 2)"
ok_write "write 'hello'" put 2 hello
check "read back 'hello'" "hello" "$(get 2)"
ok_write "write 'ab' with '>'" put 2 ab
check "shorter write with '>' replaces data (O_TRUNC)" "ab" "$(get 2)"
out=$(sudo sh -c '{ printf ab; printf cd; } > "$1"' sh $(dev 2) 2>&1) ||
	bad "two writes on one open file" "writes succeed" "$out"
check "second write on same fd continues at *ppos" "abcd" "$(get 2)"
check "1-byte reads (dd bs=1) return everything" "abcd" "$(sudo dd if=$(dev 2) bs=1 status=none 2>&1)"
check "a second read of the same data still works" "abcd" "$(get 2)"

echo "== overwrite in place: data_len rule (bank 3)"
ok_write "write 'hello world'" put 3 "hello world"
ok_write "open with '<>' (no O_TRUNC) and write 'HEY' at 0" overwrite 3 HEY
check "overwriting the start keeps the rest (data_len stays 11)" "HEYlo world" "$(get 3)"
ok_write "open with '<>' and write 20 bytes at 0" overwrite 3 "ABCDEFGHIJKLMNOPQRST"
check "writing past the end grows data_len to 20" "ABCDEFGHIJKLMNOPQRST" "$(get 3)"

echo "== O_APPEND (bank 1)"
ok_write "write 'hello' with '>'" put 1 hello
ok_write "append ' world' with '>>'" append 1 " world"
check "'>>' appends instead of overwriting" "hello world" "$(get 1)"
ok_write "append '!' again" append 1 "!"
check "a second append goes to the new end" "hello world!" "$(get 1)"
check "'>>' does not truncate" "hello world!" "$(get 1)"

echo "== unload refused while open"
sudo sh -c 'exec 3<"$1"; sleep 3' sh $(dev 3) &
holder=$!
sleep 1
rc=$(cat /sys/module/$MOD/refcnt 2>&1)
if [ "$rc" = 0 ]; then
	# Unloading now would leave an open file pointing into freed module
	# code, so don't even try.
	bad "module refcount rises while $(dev 3) is open" "refcnt >= 1 (hint: .owner)" "refcnt $rc"
else
	ok "module refcount rises while $(dev 3) is open (refcnt $rc)"
	out=$(sudo rmmod $MOD 2>&1) &&
		bad "rmmod refused while open" "rmmod: ERROR: Module kbank is in use" "rmmod succeeded" ||
		ok "rmmod refused while open"
fi
wait $holder

echo "== unload"
mark t2
out=$(unload) || bad "rmmod" "rmmod succeeds" "$out"
check "unload message" "kbank: unregistered" "$(mod_log t2)"
check_gone "after unload"

echo "== reload (did unload clean up?)"
out=$(load) || bad "insmod a second time" "insmod succeeds" "$out"
check "reloaded bank 0 reads empty" "" "$(get 0)"
unload >/dev/null

echo "== small banks (nbanks=2 size=16)"
mark t3
out=$(load nbanks=2 size=16) || bad "insmod nbanks=2 size=16" "insmod succeeds" "$out"
check "load message" "kbank: registered 2 devices, major $(major) (size=16)" "$(mod_log t3)"
check "only 2 devices" "${MOD}0 ${MOD}1" "$(ls /dev | grep "^$MOD" | xargs)"
full_write "20 bytes into a 16-byte bank: 16 fit, then ENOSPC" put 0 "$(printf '%020d' 0)"
check "bank holds the first 16 bytes" "$(printf '%016d' 0)" "$(get 0)"
full_write "appending to a full bank gives ENOSPC" append 0 x
check "full bank unchanged" "$(printf '%016d' 0)" "$(get 0)"
check "the other bank is unaffected" "" "$(get 1)"
ok_write "write 10 bytes to bank 1" put 1 0123456789
full_write "append 10 more: 6 fit, then ENOSPC" append 1 abcdefghij
check "append stopped at the bank size" "0123456789abcdef" "$(get 1)"
unload >/dev/null

echo "== invalid parameters must fail the load and leave nothing behind"
load_fails "nbanks=0" "Invalid argument" nbanks=0
load_fails "nbanks=9" "Invalid argument" nbanks=9
load_fails "nbanks=-1" "Invalid argument" nbanks=-1
load_fails "size=0" "Invalid argument" size=0
load_fails "size=65537" "Invalid argument" size=65537
load_fails "fail_at=6" "Invalid argument" fail_at=6
load_fails "fail_at=-1" "Invalid argument" fail_at=-1

echo "== forced init failures (nbanks=3): every unwind path"
load_fails "fail_at=1 (bank array)" "Cannot allocate memory" nbanks=3 fail_at=1
load_fails "fail_at=2 (last buffer)" "Cannot allocate memory" nbanks=3 fail_at=2
load_fails "fail_at=3 (cdev_add)" "No such device" nbanks=3 fail_at=3
load_fails "fail_at=4 (class_create)" "No such device" nbanks=3 fail_at=4
load_fails "fail_at=5 (last device)" "No such device" nbanks=3 fail_at=5
# A leaked class or device number makes the next load fail (class_create
# returns -EEXIST), so this catches leaks the checks above can miss.
mark t4
out=$(load nbanks=3) && ok "a normal load still works after all forced failures" ||
	bad "a normal load still works after all forced failures" "insmod succeeds" \
		"$out"$'\n'"$(mod_log t4)"
check "and creates all 3 devices" "${MOD}0 ${MOD}1 ${MOD}2" "$(ls /dev | grep "^$MOD" | xargs)"
unload >/dev/null
check_gone "after the final unload"

echo "== kernel health"
check "no oops, BUG, or WARN in the kernel log" "" \
	"$(log_since t1 | grep -E 'BUG|Oops|WARNING|general protection|KASAN|UBSAN|refcount_t')"

echo
echo "== kernel log for this run"
log_since t1 | sed 's/^\[[^]]*\] //'

echo
echo "Passed: $pass  Failed: $fail"
[ "$fail" -eq 0 ]
