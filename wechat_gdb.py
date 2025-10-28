import gdb
import re
import time
import sys
sys.stdout = sys.stderr
relative = "0x658FC90"
base = next(line.split()[0] for line in gdb.execute("info proc mapping", to_string=True).splitlines() if line.strip().endswith('/wechat'))
print(f"base = {base}, relative = {relative}")
bp = gdb.Breakpoint(f"* {base} + {relative}")
print("breakpoint has been set, please login wechat")
gdb.execute("continue") # wait to breakpoint
print(f"hit_count = {bp.hit_count}, now, reading memory")
assert gdb.execute("x/1gx $rsi+16", to_string=True).strip().endswith('0x0000000000000020'), "expect size == 0x20 == 32 bytes"
key = re.compile(r"^.*?:\s*|0x|\s+", re.MULTILINE).sub("", gdb.execute("x/32bx *(void**)($rsi+8)", to_string=True))
print(f"key = {key}")
time.sleep(1)
exit(0)
# sudo gdb --pid=$(pgrep wechat) --batch-silent --command=wechat_gdb.py
