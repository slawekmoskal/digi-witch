"""Builds assets/content/<lang>/iching.json from tool/l10n/iching_<lang>.txt
(lines "n | name | text | advice | line1 || … || line6"); other fields come from English."""
import json, sys
root, lang = sys.argv[1], sys.argv[2]
en = json.load(open(f"{root}/assets/content/en/iching.json", encoding="utf-8"))
rows = open(f"{root}/tool/l10n/iching_{lang}.txt", encoding="utf-8").read().strip().split("\n")
assert len(rows) == len(en) == 64, len(rows)
out = []
for h, row in zip(en, rows):
    n, name, text, advice, lines = row.split(" | ")
    lines = lines.split(" || ")
    assert int(n) == h["n"] and len(lines) == 6, (n, len(lines))
    out.append({**h, "name": name, "text": text, "advice": advice, "lines": lines})
open(f"{root}/assets/content/{lang}/iching.json", "w", encoding="utf-8").write(json.dumps(out, ensure_ascii=False, indent=1) + "\n")
print("ok", len(out))
