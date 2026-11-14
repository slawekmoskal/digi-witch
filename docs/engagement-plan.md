# Codzienne otwieranie aplikacji — plan

Cel: powód, by zajrzeć codziennie choćby na kilka sekund — nowa, osobista treść, bez poczucia winy i bez ciemnych wzorców.

## Zasady
- Bez serii, które przepadają, liczników „stracisz postęp”, fałszywej pilności, powiadomień bez zgody.
- Wszystko liczone offline na urządzeniu; brak analityki. Retencję (DAU, D1/D7/D30) czytamy z App Store Connect i Google Play Console.

## Etap 1 — największy efekt
| # | Funkcja | Stan |
|---|---------|------|
| 3 | Rytuał 10 s na Dziś: karta dnia zakryta, odsłaniana stuknięciem (obrót), pod nią „Jak się dziś czujesz?” (5 ikon, zapis lokalny) | **zrobione** |
| 2 | Powiadomienie z treścią dnia: „Pełnia · Księżyc w Raku · liczba dnia 8 · karta dnia czeka” — 30 dni planowanych z góry, odświeżane przy starcie | **zrobione** |
| 7 | Odliczania na Dziś: pełnia/nów za N dni, zaćmienie (≤ 60 dni), Merkury wsteczny (≤ 30), urodziny (≤ 30) | **zrobione** |
| 1 | Widżet ekranu głównego i blokady (iOS WidgetKit, Android App Widget, pakiet `home_widget`): trzy widżety — Dziś dla Ciebie (horoskop), Karta dnia, Księżyc — z głębokimi linkami | **zrobione** |

## Etap 2 — powód, by wrócić jutro
- 4. „Twoja talia”: kolekcja 78 kart dnia z datami.
- 5. Kalendarz praktyki: kropki za dni z kartą/wpisem, bez serii.
- 6. „Ty i Księżyc”: nastrój na tle faz (dane z punktu 3).
- 8. Drobiazg dnia: symbol z sennika, heksagram dnia, myśl dnia.

## Etap 3 — wygoda i zasięg
- 9. Skróty z ikony (Karta dnia, Tak/Nie, Księżyc), Siri/App Shortcuts.
- 10. Udostępnianie grafiki karty/horoskopu (Stories).
- 11. Niedzielne „Twój tydzień” (opcjonalne powiadomienie).
