"""Merges tool/l10n/<dir>/*.json into one JSON file and checks it has the same shape
as the English one: same keys, same list lengths, same ids.
Usage: python3 tool/l10n/merge_json.py <repo root> <parts dir> <content file> <lang>"""
import json, glob, sys
root, parts, name, lang = sys.argv[1:5]
out = {}
for f in sorted(glob.glob(f"{root}/tool/l10n/{parts}/*.json")):
    out.update(json.load(open(f, encoding="utf-8")))
en = json.load(open(f"{root}/assets/content/en/{name}", encoding="utf-8"))
def same(a, b, path):
    assert type(a) == type(b), (path, type(a), type(b))
    if isinstance(a, dict):
        assert a.keys() == b.keys(), (path, set(a) ^ set(b))
        for k in a:
            if k == "id": assert a[k] == b[k], (path, a[k], b[k])
            same(a[k], b[k], f"{path}.{k}")
    elif isinstance(a, list):
        assert len(a) == len(b), (path, len(a), len(b))
        for i, (x, y) in enumerate(zip(a, b)): same(x, y, f"{path}[{i}]")
same(out, en, name)
out = {k: out[k] for k in en}  # English key order
open(f"{root}/assets/content/{lang}/{name}", "w", encoding="utf-8").write(json.dumps(out, ensure_ascii=False, indent=1) + "\n")
print("ok", name, lang)
