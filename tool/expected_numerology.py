#!/usr/bin/env python3
"""Independent oracle for numerology test cases (NOT production code).

Written separately from lib/engine so test expectations do not come from the code under test.
Run: python3 tool/expected_numerology.py  -> prints test/fixtures/numerology_cases.json content.
"""
import json
from datetime import date

PL = str.maketrans("ĄĆĘŁŃÓŚŹŻ", "ACELNOSZZ")
VOWELS = set("AEIOUY")


def letter_value(ch):
    return (ord(ch) - ord("A")) % 9 + 1


def digit_sum(n):
    return sum(int(c) for c in str(n))


def reduce(n, masters):
    while n > 9 and n not in masters:
        n = digit_sum(n)
    return n


def life_path(d):
    return reduce(sum(int(c) for c in d.strftime("%Y%m%d")), {11, 22, 33})


def life_path_separate(d):
    """Alternative school: reduce day, month, year separately (for documenting differences)."""
    m = {11, 22, 33}
    return reduce(reduce(d.day, m) + reduce(d.month, m) + reduce(digit_sum(d.year), m), m)


def birth_day(d):
    return reduce(d.day, {11, 22})


def personal_year(d, year):
    return reduce(digit_sum(d.day) + digit_sum(d.month) + digit_sum(year), set())


def letters(name):
    norm = name.upper().translate(PL)
    out = [c for c in norm if c not in " -'’"]
    assert all("A" <= c <= "Z" for c in out), name
    return out


def name_number(name, pick):
    s = sum(letter_value(c) for c in letters(name) if pick(c))
    return None if s == 0 else reduce(s, {11, 22, 33})


DATES = ["1990-07-15", "1985-11-29", "2000-02-29", "2024-02-29", "1938-12-31", "1975-05-29",
         "1951-01-01", "1999-09-09", "1987-11-22", "1969-12-29", "1950-01-04", "1951-02-13", "1954-06-08"]
NAMES = ["Łukasz Żółć", "Anna Maria Kowalska-Nowak", "Ewa", "Grzegorz Brzęczyszczykiewicz",
         "Krzysztof", "Zofia O'Neill", "Ścibor Źrebięcki"]

cases = {
    "dates": [
        {"date": s, "lifePath": life_path(d), "lifePathSeparateSchool": life_path_separate(d),
         "birthDay": birth_day(d), "personalYear2026": personal_year(d, 2026)}
        for s in DATES for d in [date.fromisoformat(s)]
    ],
    "names": [
        {"name": n, "expression": name_number(n, lambda c: True),
         "soulUrge": name_number(n, lambda c: c in VOWELS),
         "personality": name_number(n, lambda c: c not in VOWELS)}
        for n in NAMES
    ],
}
print(json.dumps(cases, ensure_ascii=False, indent=2))
