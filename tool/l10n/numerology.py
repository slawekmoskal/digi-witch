"""Builds assets/content/<lang>/numerology.json from tool/l10n/numerology_<lang>.txt
(lines "indicator n | title | text | reflection"); keys and order follow English."""
import json, sys
root, lang = sys.argv[1], sys.argv[2]
en = json.load(open(f"{root}/assets/content/en/numerology.json", encoding="utf-8"))
t = {}
for row in open(f"{root}/tool/l10n/numerology_{lang}.txt", encoding="utf-8").read().strip().split("\n"):
    head, title, text, refl = row.split(" | ")
    ind, n = head.split(" ")
    assert (ind, n) not in t, head
    t[(ind, n)] = {"title": title, "text": text, "reflection": refl}
want = {(i, n) for i in en for n in en[i]}
assert want == set(t), (want ^ set(t))
out = {i: {n: {**en[i][n], **t[(i, n)]} for n in en[i]} for i in en}
open(f"{root}/assets/content/{lang}/numerology.json", "w", encoding="utf-8").write(json.dumps(out, ensure_ascii=False, indent=1) + "\n")
print("ok", len(t))
