"""Checks assets/content/<lang>/ against the Polish originals: same files, same keys, same
list lengths, strings present, and a few likely mistakes. Usage: python3 tool/l10n/check_content.py <lang> [root]"""
import json, re, sys, os
lang = sys.argv[1]; root = sys.argv[2] if len(sys.argv) > 2 else "."
NAMES = ["archetypes", "articles", "astro", "dreams", "glossary", "iching", "journal_prompts", "messages",
         "numerology", "numerology_extra", "tarot_part_a", "tarot_part_b"]
polish = re.compile("[ąćęłńśźżĄĆĘŁŃŚŹŻ]")
ok = True
def load(p): return json.load(open(p, encoding="utf-8"))
def walk(a, b, path, out):
    if isinstance(a, dict):
        if not isinstance(b, dict): out.append(f"{path}: not an object"); return
        for k in a.keys() - b.keys(): out.append(f"{path}/{k}: missing")
        for k in b.keys() - a.keys(): out.append(f"{path}/{k}: extra")
        for k in a.keys() & b.keys(): walk(a[k], b[k], f"{path}/{k}", out)
    elif isinstance(a, list):
        if not isinstance(b, list) or len(a) != len(b): out.append(f"{path}: list length {len(b) if isinstance(b, list) else '?'} != {len(a)}"); return
        for i, (x, y) in enumerate(zip(a, b)): walk(x, y, f"{path}[{i}]", out)
    elif isinstance(a, str):
        if not isinstance(b, str) or (a.strip() and not b.strip()): out.append(f"{path}: text missing")
    elif a != b: out.append(f"{path}: value differs ({a!r} vs {b!r})")
def strings(x):
    if isinstance(x, str): yield x
    elif isinstance(x, dict): yield from (s for v in x.values() for s in strings(v))
    elif isinstance(x, list): yield from (s for v in x for s in strings(v))
for n in NAMES:
    pl = load(f"{root}/assets/content/{n}.json")
    p = f"{root}/assets/content/{lang}/{n}.json"
    if not os.path.exists(p): print("MISSING FILE", p); ok = False; continue
    d = load(p); out = []
    walk(pl, d, n, out)
    en = load(f"{root}/assets/content/en/{n}.json")
    same = sum(1 for a, b in zip(strings(en), strings(d)) if len(a) > 30 and a == b)
    pol = sum(1 for s in strings(d) if polish.search(s))
    if same: out.append(f"{n}: {same} long strings identical to English (untranslated?)")
    if pol: out.append(f"{n}: {pol} strings contain Polish letters")
    for o in out[:15]: print(o)
    if len(out) > 15: print(f"... and {len(out) - 15} more in {n}")
    ok &= not out
m = load(f"{root}/assets/content/{lang}/messages.json") if os.path.exists(f"{root}/assets/content/{lang}/messages.json") else []
if m and (len(m) != 180 or len(set(m)) != 180 or max(map(len, m)) > 70): print("messages: need 180 unique lines of at most 70 characters"); ok = False
print("ok" if ok else "FAILED"); sys.exit(0 if ok else 1)
