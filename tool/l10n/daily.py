"""Builds the daily reading texts from tool/l10n/daily_<lang>/*.json and checks their shape.
Polish goes to assets/content/daily.json, other languages to assets/content/<lang>/daily.json.
Usage: python3 tool/l10n/daily.py <repo root> <lang>"""
import json, glob, sys
root, lang = sys.argv[1], sys.argv[2]
d = {}
for f in sorted(glob.glob(f"{root}/tool/l10n/daily_{lang}/*.json")):
    part = json.load(open(f, encoding="utf-8"))
    d.update({"mood": part} if f.endswith("mood.json") else part)  # mood.json is keyed by sign
SIGNS = ["aries", "taurus", "gemini", "cancer", "leo", "virgo", "libra", "scorpio", "sagittarius", "capricorn", "aquarius", "pisces"]
assert list(d["mood"]) == SIGNS, list(d["mood"])
for s in SIGNS:
    assert set(d["mood"][s]) == {"same", "supportive", "neutral", "tense"}, s
    assert all(len(v) == 2 for v in d["mood"][s].values()), s
for k in ("events", "advice"):
    assert list(d[k]) == [str(i) for i in range(1, 10)] and all(len(v) == 3 for v in d[k].values()), k
for k in ("love", "work", "energy"):
    assert list(d[k]) == ["low", "mid", "high"] and all(len(v) == 3 for v in d[k].values()), k
assert d["birthday"]
texts = [t for s in d["mood"].values() for v in s.values() for t in v] + [t for k in ("events", "advice", "love", "work", "energy") for v in d[k].values() for t in v]
assert len(set(texts)) == len(texts), "duplicate text"
out = f"{root}/assets/content/daily.json" if lang == "pl" else f"{root}/assets/content/{lang}/daily.json"
open(out, "w", encoding="utf-8").write(json.dumps(d, ensure_ascii=False, indent=1) + "\n")
print("ok", lang, len(texts) + 1)
