"""Builds assets/content/<lang>/tarot_part_{a,b}.json from tool/l10n/tarot_<lang>/*.json.
Ids, arcana, suit and rank come from the Polish files; the astrology line is translated
word by word with the table below. Usage: python3 tool/l10n/tarot.py <repo root> <lang>"""
import json, glob, sys, collections
root, lang = sys.argv[1], sys.argv[2]
# Polish word → translation; "w Baranie" style phrases are matched before bare sign names.
WORDS = {
 "de": {"Ogień": "Feuer", "Woda": "Wasser", "Powietrze": "Luft", "Ziemia": "Erde", "źródło żywiołu": "Wurzel des Elements",
  "Słońce": "Sonne", "Księżyc": "Mond", "Merkury": "Merkur", "Wenus": "Venus", "Mars": "Mars", "Jowisz": "Jupiter", "Saturn": "Saturn",
  "w Baranie": "im Widder", "w Byku": "im Stier", "w Bliźniętach": "in den Zwillingen", "w Raku": "im Krebs", "w Lwie": "im Löwen",
  "w Pannie": "in der Jungfrau", "w Wadze": "in der Waage", "w Skorpionie": "im Skorpion", "w Strzelcu": "im Schützen",
  "w Koziorożcu": "im Steinbock", "w Wodniku": "im Wassermann", "w Rybach": "in den Fischen",
  "Baran": "Widder", "Byk": "Stier", "Bliźnięta": "Zwillinge", "Rak": "Krebs", "Lew": "Löwe", "Panna": "Jungfrau",
  "Waga": "Waage", "Skorpion": "Skorpion", "Strzelec": "Schütze", "Koziorożec": "Steinbock", "Wodnik": "Wassermann", "Ryby": "Fische"},
 "fr": {"Ogień": "Feu", "Woda": "Eau", "Powietrze": "Air", "Ziemia": "Terre", "źródło żywiołu": "racine de l’élément",
  "Słońce": "Soleil", "Księżyc": "Lune", "Merkury": "Mercure", "Wenus": "Vénus", "Mars": "Mars", "Jowisz": "Jupiter", "Saturn": "Saturne",
  "w Baranie": "en Bélier", "w Byku": "en Taureau", "w Bliźniętach": "en Gémeaux", "w Raku": "en Cancer", "w Lwie": "en Lion",
  "w Pannie": "en Vierge", "w Wadze": "en Balance", "w Skorpionie": "en Scorpion", "w Strzelcu": "en Sagittaire",
  "w Koziorożcu": "en Capricorne", "w Wodniku": "en Verseau", "w Rybach": "en Poissons",
  "Baran": "Bélier", "Byk": "Taureau", "Bliźnięta": "Gémeaux", "Rak": "Cancer", "Lew": "Lion", "Panna": "Vierge",
  "Waga": "Balance", "Skorpion": "Scorpion", "Strzelec": "Sagittaire", "Koziorożec": "Capricorne", "Wodnik": "Verseau", "Ryby": "Poissons"},
 "es": {"Ogień": "Fuego", "Woda": "Agua", "Powietrze": "Aire", "Ziemia": "Tierra", "źródło żywiołu": "raíz del elemento",
  "Słońce": "Sol", "Księżyc": "Luna", "Merkury": "Mercurio", "Wenus": "Venus", "Mars": "Marte", "Jowisz": "Júpiter", "Saturn": "Saturno",
  "w Baranie": "en Aries", "w Byku": "en Tauro", "w Bliźniętach": "en Géminis", "w Raku": "en Cáncer", "w Lwie": "en Leo",
  "w Pannie": "en Virgo", "w Wadze": "en Libra", "w Skorpionie": "en Escorpio", "w Strzelcu": "en Sagitario",
  "w Koziorożcu": "en Capricornio", "w Wodniku": "en Acuario", "w Rybach": "en Piscis",
  "Baran": "Aries", "Byk": "Tauro", "Bliźnięta": "Géminis", "Rak": "Cáncer", "Lew": "Leo", "Panna": "Virgo",
  "Waga": "Libra", "Skorpion": "Escorpio", "Strzelec": "Sagitario", "Koziorożec": "Capricornio", "Wodnik": "Acuario", "Ryby": "Piscis"},
 "uk": {"Ogień": "Вогонь", "Woda": "Вода", "Powietrze": "Повітря", "Ziemia": "Земля", "źródło żywiołu": "корінь стихії",
  "Słońce": "Сонце", "Księżyc": "Місяць", "Merkury": "Меркурій", "Wenus": "Венера", "Mars": "Марс", "Jowisz": "Юпітер", "Saturn": "Сатурн",
  "w Baranie": "в Овні", "w Byku": "у Тельці", "w Bliźniętach": "у Близнюках", "w Raku": "у Раку", "w Lwie": "у Леві",
  "w Pannie": "у Діві", "w Wadze": "у Терезах", "w Skorpionie": "у Скорпіоні", "w Strzelcu": "у Стрільці",
  "w Koziorożcu": "у Козерозі", "w Wodniku": "у Водолії", "w Rybach": "у Рибах",
  "Baran": "Овен", "Byk": "Телець", "Bliźnięta": "Близнюки", "Rak": "Рак", "Lew": "Лев", "Panna": "Діва",
  "Waga": "Терези", "Skorpion": "Скорпіон", "Strzelec": "Стрілець", "Koziorożec": "Козеріг", "Wodnik": "Водолій", "Ryby": "Риби"},
}[lang]
def astro(s):
    out = s
    for k in sorted(WORDS, key=len, reverse=True):
        out = out.replace(k, WORDS[k])
    assert not any(c in out for c in "ąćęłńśźżĄĆĘŁŃŚŹŻ"), (s, out)
    return out
t = {}
for f in sorted(glob.glob(f"{root}/tool/l10n/tarot_{lang}/*.json")):
    for c in json.load(open(f, encoding="utf-8")):
        assert c["id"] not in t, c["id"]
        t[c["id"]] = c
assert len(t) == 78, len(t)
for part in "ab":
    pl = json.load(open(f"{root}/assets/content/tarot_part_{part}.json", encoding="utf-8"), object_pairs_hook=collections.OrderedDict)
    out = []
    for c in pl:
        x = t[c["id"]]
        assert len(x["keywords"]) == len(c["keywords"]) and len(x["reflection"]) == len(c["reflection"]), c["id"]
        d = collections.OrderedDict(c)
        for k in ["name", "keywords", "symbolism", "upright", "reversed", "reflection", "advice", "adviceReversed"]:
            d[k] = x[k]
        d["astrology"] = astro(c["astrology"])
        out.append(d)
    json.dump(out, open(f"{root}/assets/content/{lang}/tarot_part_{part}.json", "w", encoding="utf-8"), ensure_ascii=False, indent=1)
print("ok", lang, len(t))
