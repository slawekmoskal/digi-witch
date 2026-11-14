"""Builds assets/content/en/tarot_part_{a,b}.json from tool/l10n/tarot_en/*.json; structure copied from the Polish files."""
import json, glob, sys, collections
root = sys.argv[1]
en = {}
for f in sorted(glob.glob(f"{root}/tool/l10n/tarot_en/*.json")):
    for c in json.load(open(f, encoding="utf-8")):
        en[c["id"]] = c
WORDS = {"Ogień": "Fire", "Woda": "Water", "Powietrze": "Air", "Ziemia": "Earth", "źródło żywiołu": "root of the element",
 "Słońce": "Sun", "Księżyc": "Moon", "Merkury": "Mercury", "Wenus": "Venus", "Mars": "Mars", "Jowisz": "Jupiter", "Saturn": "Saturn",
 "w Baranie": "in Aries", "w Byku": "in Taurus", "w Bliźniętach": "in Gemini", "w Raku": "in Cancer", "w Lwie": "in Leo", "w Pannie": "in Virgo",
 "w Wadze": "in Libra", "w Skorpionie": "in Scorpio", "w Strzelcu": "in Sagittarius", "w Koziorożcu": "in Capricorn", "w Wodniku": "in Aquarius", "w Rybach": "in Pisces",
 "Baran": "Aries", "Byk": "Taurus", "Bliźnięta": "Gemini", "Rak": "Cancer", "Lew": "Leo", "Panna": "Virgo", "Waga": "Libra", "Skorpion": "Scorpio",
 "Strzelec": "Sagittarius", "Koziorożec": "Capricorn", "Wodnik": "Aquarius", "Ryby": "Pisces"}
def astro(s):
    out = s
    for k in sorted(WORDS, key=len, reverse=True):  # "w Baranie" before "Baran"
        out = out.replace(k, WORDS[k])
    assert all(ord(ch) < 0x0100 or ch in "·—" for ch in out), (s, out)
    return out
for part in "ab":
    pl = json.load(open(f"{root}/assets/content/tarot_part_{part}.json", encoding="utf-8"), object_pairs_hook=collections.OrderedDict)
    out = []
    for c in pl:
        t = en[c["id"]]
        assert len(t["keywords"]) == len(c["keywords"]) and len(t["reflection"]) == len(c["reflection"]), c["id"]
        d = collections.OrderedDict(c)
        for k in ["name", "keywords", "symbolism", "upright", "reversed", "reflection", "advice", "adviceReversed"]:
            d[k] = t[k]
        d["astrology"] = astro(c["astrology"])
        out.append(d)
    json.dump(out, open(f"{root}/assets/content/en/tarot_part_{part}.json", "w", encoding="utf-8"), ensure_ascii=False, indent=1)
assert len(en) == 78
print("ok", len(en))
