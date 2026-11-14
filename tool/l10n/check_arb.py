"""Checks every lib/l10n/app_<lang>.arb against app_pl.arb: same keys, same {placeholders}."""
import json, glob, re, sys
root = sys.argv[1] if len(sys.argv) > 1 else "."
pl = json.load(open(f"{root}/lib/l10n/app_pl.arb", encoding="utf-8"))
keys = {k for k in pl if not k.startswith("@")}
# Top-level placeholder names only: {x} or {x, select|plural, ...}.
names = lambda v: set(re.findall(r"(?<![{\w])\{(\w+)(?=[},])", v))
ok = True
for f in sorted(glob.glob(f"{root}/lib/l10n/app_*.arb")):
    d = json.load(open(f, encoding="utf-8"))
    got = {k for k in d if not k.startswith("@")}
    for k in sorted(keys - got): print(f, "missing", k); ok = False
    for k in sorted(got - keys): print(f, "extra", k); ok = False
    for k in keys & got:
        if names(d[k]) - names(pl[k]): print(f, k, "placeholders", names(d[k]), names(pl[k])); ok = False
print("ok" if ok else "FAILED"); sys.exit(0 if ok else 1)
