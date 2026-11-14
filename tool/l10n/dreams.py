"""Builds assets/content/<lang>/dreams.json from tool/l10n/dreams_<lang>.txt
(lines "symbol | meaning | reflection"), sorted alphabetically for that language."""
import json, sys, unicodedata
root, lang = sys.argv[1], sys.argv[2]
rows = [l.split(" | ") for l in open(f"{root}/tool/l10n/dreams_{lang}.txt", encoding="utf-8").read().strip().split("\n")]
assert all(len(r) == 3 for r in rows), [r for r in rows if len(r) != 3]
n = len(json.load(open(f"{root}/assets/content/dreams.json", encoding="utf-8")))
assert len(rows) == n, (len(rows), n)
assert len({r[0] for r in rows}) == n, "duplicate symbol"
# Accents sort with their base letter (ä with a, é with e); ß as ss.
latin = lambda r: "".join(c for c in unicodedata.normalize("NFD", r[0].casefold().replace("ß", "ss")) if not unicodedata.combining(c))
# Ukrainian: alphabet order (ґ after г, є after е, і ї after и, й after ї); й and ї keep their marks.
UK = "абвгґдеєжзиіїйклмнопрстуфхцчшщьюя"
cyrillic = lambda r: [UK.index(c) if c in UK else 100 + ord(c) for c in r[0].casefold().replace("’", "")]
key = cyrillic if lang == "uk" else latin
out = [{"symbol": s, "meaning": m, "reflection": q} for s, m, q in sorted(rows, key=key)]
open(f"{root}/assets/content/{lang}/dreams.json", "w", encoding="utf-8").write(json.dumps(out, ensure_ascii=False, indent=1) + "\n")
print("ok", len(out))
