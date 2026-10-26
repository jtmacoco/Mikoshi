#!/usr/bin/env bash
# Test script for 01-greeter-params. Run inside the VM: ./test.sh
set -u
cd "$(dirname "$0")"

# Copy all output to test_output.txt so the tutor can read it.
exec > >(tee test_output.txt) 2>&1
echo "run: $(date '+%F %T')  kernel: $(uname -r)  host: $(uname -n)"
echo "greeter.c sha256: $(sha256sum greeter.c | cut -d' ' -f1)"

MOD=greeter
KO=./$MOD.ko
SYS=/sys/module/$MOD/parameters
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

# Write a marker into the kernel log so we only inspect messages after it.
# RUN makes markers unique per run, so earlier runs' messages are ignored.
RUN=$$.$(date +%s)
mark() { echo "greeter-test: $RUN $1" | sudo tee /dev/kmsg >/dev/null; }
log_since() { sudo dmesg | sed -n "/greeter-test: $RUN $1\$/,\$p"; }
# What the module logged since a marker, minus timestamps and test markers.
mod_log() { log_since "$1" | grep -v 'greeter-test: ' | sed 's/^\[[^]]*\] //'; }
loaded() { lsmod | grep -q "^$MOD "; }

sudo rmmod $MOD 2>/dev/null

echo "== build"
make -s || { echo "build failed"; exit 1; }

echo "== modinfo"
params=$(modinfo -p $KO 2>&1)
n=$(grep -cE '^(name|count|verbose):[^ ]' <<<"$params")
[ "$n" -eq 3 ] && ok "all 3 params have descriptions" ||
	bad "modinfo -p shows $n/3 described params" \
	    $'name:<description> (charp)\ncount:<description> (int)\nverbose:<description> (bool)' "$params"
for f in license author description; do
	v=$(modinfo -F $f $KO)
	[ -n "$v" ] && ok "MODULE_${f^^} set" || bad "MODULE_${f^^} missing" "a non-empty $f" "$v"
done

echo "== defaults"
mark t1
out=$(sudo insmod $KO 2>&1) || bad "insmod with defaults failed" "insmod succeeds" "$out"
log=$(mod_log t1)
[ "$(grep -c '^greeter: Hello, world$' <<<"$log")" -eq 1 ] && ok "greets world once" ||
	bad "expected exactly one 'greeter: Hello, world'" "greeter: Hello, world" "$log"
grep -q 'greeter: name=' <<<"$log" &&
	bad "verbose output printed without verbose=1" "no 'greeter: name=...' line" "$log" || ok "quiet by default"
v=$(cat $SYS/name 2>&1)
[ "$v" = world ] && ok "sysfs name=world" || bad "sysfs name wrong/missing" "world" "$v"
v=$(cat $SYS/count 2>&1)
[ "$v" = 1 ] && ok "sysfs count=1" || bad "sysfs count wrong/missing" "1" "$v"
v=$(stat -c %a $SYS/name 2>&1)
[ "$v" = 444 ] && ok "name is 0444" || bad "name perms not 0444" "444" "$v"
v=$(stat -c %a $SYS/count 2>&1)
[ "$v" = 644 ] && ok "count is 0644" || bad "count perms not 0644" "644" "$v"

echo "== change count via sysfs, then unload"
echo 3 | sudo tee $SYS/count >/dev/null
mark t2
out=$(sudo rmmod $MOD 2>&1) || bad "rmmod failed" "rmmod succeeds" "$out"
log=$(mod_log t2)
grep -q '^greeter: Goodbye, world (count=3)$' <<<"$log" && ok "goodbye uses updated count" ||
	bad "expected 'greeter: Goodbye, world (count=3)'" "greeter: Goodbye, world (count=3)" "$log"

echo "== custom params + verbose"
mark t3
out=$(sudo insmod $KO name=Linus count=4 verbose=1 2>&1) ||
	bad "insmod with params failed" "insmod succeeds" "$out"
log=$(mod_log t3)
[ "$(grep -c '^greeter: Hello, Linus$' <<<"$log")" -eq 4 ] && ok "greets Linus 4 times" ||
	bad "expected 4x 'greeter: Hello, Linus'" "$(printf 'greeter: Hello, Linus\n%.0s' 1 2 3 4)" "$log"
grep -q '^greeter: name=Linus count=4$' <<<"$log" && ok "verbose line printed" ||
	bad "expected 'greeter: name=Linus count=4'" "greeter: name=Linus count=4" "$log"
sudo rmmod $MOD 2>/dev/null

echo "== invalid count must fail the load"
for c in 0 11 -5; do
	mark "t4$c"
	if out=$(sudo insmod $KO count=$c 2>&1); then
		bad "insmod count=$c succeeded" "insmod fails with an error" "insmod succeeded"
		sudo rmmod $MOD 2>/dev/null
	else
		loaded && bad "count=$c: module still loaded" "module not in lsmod" "$(lsmod | grep "^$MOD ")" ||
			ok "count=$c rejected"
	fi
	log=$(mod_log "t4$c")
	grep -q '^greeter: ' <<<"$log" && ok "count=$c: error logged" ||
		bad "count=$c: no greeter: message logged" "a 'greeter: ...' error line" "$log"
	grep -q 'greeter: Hello' <<<"$log" &&
		bad "count=$c: greeted before failing" "no 'greeter: Hello' line" "$log" || true
done

echo
echo "== kernel log for this run"
log_since t1 | sed 's/^\[[^]]*\] //'

echo
echo "Passed: $pass  Failed: $fail"
[ "$fail" -eq 0 ]
