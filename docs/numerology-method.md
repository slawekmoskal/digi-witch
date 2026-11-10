# Metoda obliczeń numerologicznych — konwencja produktu

Wersja algorytmu: `pl-pyth-1` (stała `algorithmVersion` w `lib/engine/numerology.dart`).

Nie istnieje jeden algorytm wspólny dla wszystkich szkół numerologii. Poniżej opisujemy **jedną, jawnie wybraną konwencję produktu**. Nie jest to historyczny konsensus ani jedyna poprawna metoda. Każda zmiana reguł wymaga podbicia wersji algorytmu. Zapisane wpisy w dzienniku zachowują wersję, z którą je policzono, oraz pełny ślad obliczenia.

## Redukcja

```
reduce(n, mistrzowskie):
    dopóki n > 9 i n nie należy do mistrzowskie:
        n = suma cyfr n
    zwróć n
```

Funkcja redukcji jest oddzielona od interpretacji, formatowania i UI (`reduceSteps` zwraca wszystkie pośrednie wartości do śladu).

## Reguły wskaźników

| Wskaźnik | Dane | Co sumujemy | Zachowane liczby mistrzowskie | Zakres |
|---|---|---|---|---|
| Droga życia | data | **wszystkie cyfry** pełnej daty DDMMRRRR naraz | 11, 22, 33 | 1–9, 11, 22, 33 |
| Liczba dnia urodzenia | dzień | cyfry dnia | 11, 22 | 1–9, 11, 22 (33 nieosiągalne) |
| Liczba ekspresji | imię i nazwisko | wartości wszystkich liter | 11, 22, 33 | 1–9, 11, 22, 33 |
| Liczba samogłosek | imię i nazwisko | wartości A, E, I, O, U, Y | 11, 22, 33 | jw. lub „brak podstaw” |
| Liczba spółgłosek | imię i nazwisko | wartości pozostałych liter | 11, 22, 33 | jw. lub „brak podstaw” |
| Rok osobisty | dzień, miesiąc, wybrany rok | suma cyfr dnia + suma cyfr miesiąca + suma cyfr roku | brak | 1–9 |

Rok osobisty: granica 1 stycznia (rok kalendarzowy). Inne konwencje (np. od urodzin) mogą być dodane tylko jako jawne, osobne ustawienie.

## Litery

Tabela A–Z cyklicznie 1–9:

| 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |
|---|---|---|---|---|---|---|---|---|
| A | B | C | D | E | F | G | H | I |
| J | K | L | M | N | O | P | Q | R |
| S | T | U | V | W | X | Y | Z |   |

Normalizacja polskich liter — **jawna tabela**, nie usuwanie diakrytyków (Ł nie ma rozkładu Unicode):
Ą→A, Ć→C, Ę→E, Ł→L, Ń→N, Ó→O, Ś→S, Ź→Z, Ż→Z. Wielkość liter nie ma znaczenia.

- Spacje, łączniki (`-`) i apostrofy (`'`, `’`) są pomijane. Wiele imion i nazwisk sumujemy razem jako jeden zapis.
- Oryginalny zapis jest zachowany do prezentacji; obok pokazujemy zapis po normalizacji.
- Każdy inny znak (np. `ü`, cyrylica, cyfry) **blokuje obliczenie** z komunikatem wymieniającym te znaki. Użytkownik sam wpisuje transliterację, której chce użyć. Nie pomijamy liter po cichu.
- Samogłoski w przyjętym polskim wariancie: A, E, I, O, U, Y (po normalizacji, więc Ą, Ę, Ó też). W wielu szkołach anglojęzycznych Y bywa traktowane zależnie od kontekstu — u nas zawsze jako samogłoska.
- Suma 0 w grupie (np. brak samogłosek) → „brak podstaw do obliczenia”, bez interpretacji zera.

## Data

Data jest przechowywana jako data kalendarzowa (`yyyy-mm-dd`) bez godziny i strefy; nigdy nie przechodzi przez UTC. Odrzucamy daty nieistniejące (np. 29.02.2023, 31.04) i przyszłe względem lokalnej daty urządzenia. 29 lutego w latach przestępnych jest obsługiwany (1900 nie jest przestępny, 2000 jest).

## Przykłady (wyliczone niezależnie skryptem `tool/expected_numerology.py`)

| Wejście | Wynik |
|---|---|
| 29.05.1975 | 2+9+0+5+1+9+7+5 = 38 → 3+8 = 11 (mistrzowska). Dzień 29 → 11. |
| 04.01.1950 | 0+4+0+1+1+9+5+0 = 20 → **2**. Szkoła redukująca składniki osobno: 4 + 1 + (1950 → 15 → 6) = 11. |
| 08.06.1954 | 33 (mistrzowska) u nas; **6** przy osobnej redukcji składników. |
| Łukasz Żółć | LUKASZZOLC: 3+3+2+1+1+8+8+6+3+3 = 38 → **11**; samogłoski U,A,O = 10 → 1; spółgłoski = 28 → 1. |
| Krk | samogłoski: brak podstaw do obliczenia. |
| Müller | błąd: nieobsługiwany znak „ü” — wymagana transliteracja. |

### Różnice wobec innych metod

Popularna alternatywa liczy drogę życia jako `reduce(reduce(dzień) + reduce(miesiąc) + reduce(suma cyfr roku))`. Dla wyników 1–9 obie metody dają to samo (zachowanie reszty z dzielenia przez 9), ale **różnią się przy liczbach mistrzowskich**: 04.01.1950 daje u nas 2, w metodzie osobnej 11; 13.02.1951 daje u nas 22, tam 4. Test `school difference is real` utrwala tę różnicę.

## Testy

`test/numerology_test.dart` porównuje silnik z `test/fixtures/numerology_cases.json`, wygenerowanym przez niezależną implementację w Pythonie (`python3 tool/expected_numerology.py > test/fixtures/numerology_cases.json`). Obejmuje liczby mistrzowskie, polskie znaki, łączniki/apostrofy, wiele imion, daty przestępne i nieistniejące, różnicę szkół.

## Źródła historyczne

Konwencja „pitagorejskiej” tabeli liter jest nowożytna (przełom XIX/XX w., m.in. L. Dow Balliett; później J. Jordan) i nie pochodzi bezpośrednio od Pitagorejczyków. Szczegóły i zastrzeżenia: artykuł „historia-numerologii” w `assets/content/articles.json`. Niezweryfikowane daty są tam oznaczone ostrożnym sformułowaniem.
