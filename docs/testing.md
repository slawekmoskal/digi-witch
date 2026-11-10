# Rzeczywiście wykonane testy

Uruchomienie: `flutter test` (Flutter stable, Dart 3.13.7, macOS).

## 2026-11-10 — etap 1 (MVP offline)

| Zakres | Plik | Wynik |
|---|---|---|
| Silnik numerologii vs niezależna wyrocznia w Pythonie (13 dat, 7 imion), daty nieistniejące/przestępne, Ł, separatory, nieobsługiwane znaki, brak samogłosek, różnica szkół, ślad | `test/numerology_test.dart` | 26/26 ✅ |
| Talia 78 kart, brak powtórzeń w rozkładzie, odwrócenia wyłączone, powtarzalność z ziarnem, jednorodność (chi² < 117,6 przy df=77) i ~50% odwróceń | `test/tarot_test.dart` | 5/5 ✅ |
| Spójność treści (78 kart = id silnika, brak duplikatów tekstów, interpretacja dla każdej osiągalnej liczby każdego wskaźnika, ≥30 pytań, ≥10 rodzinnych, 12 archetypów); magazyn: karta dnia po „restarcie” i zmianie daty, dziennik dodaj/edytuj/eksport/usuń z wersjami, usunięcie wszystkich danych, odwrócenia domyślnie off | `test/content_store_test.dart` | 8/8 ✅ |
| Widgety: onboarding bez rejestracji → Dzisiaj; obliczenie z samej daty z krokami; błędna data i znak „ü”; rozkład 3 kart + zapis refleksji; wyszukiwarka biblioteki; ciemny motyw + tekst 2× bez przepełnień | `test/app_flow_test.dart` | 6/6 ✅ |

Razem: **45/45** zaliczone. `flutter analyze`: brak uwag.

Testy UI wykryły i pomogły naprawić 2 realne błędy układu (przepełnienie wiersza wyboru roku, przepełnienie awersu karty przy 2× tekście).

Ręcznie: zbudowano `flutter build web --release`, uruchomiono w Chrome (headless), zrzut ekranu Dzisiaj — renderuje się poprawnie po polsku w ciemnym motywie.

## Czego NIE przetestowano

- Brak uruchomienia na Androidzie (brak Android SDK/Java) i na iOS (brak symulatora iOS 27.2 i CocoaPods).
- Brak testu z prawdziwym czytnikiem ekranu (TalkBack/VoiceOver) — są tylko etykiety semantyczne.
- Eksport dziennika (`share_plus`) nie był uruchomiony na urządzeniu.
- Reklamy, zakupy, przypomnienia — nie zaimplementowane.
