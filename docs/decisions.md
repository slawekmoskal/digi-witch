# Decyzje projektowe (ADR-lite)

Format: data — decyzja — dlaczego — konsekwencje. Najnowsze na dole.

1. **2026-11-10 — Flutter (stable 3.x, Dart 3.13).** Prompt wskazuje Flutter; właściciel potwierdził wybór wobec React Native. Jeden kod, własny UI, testy logiki/widgetów bez urządzenia, oficjalne pluginy AdMob/UMP i IAP.
2. **2026-11-10 — Brak backendu i konta.** Wszystko lokalnie (`shared_preferences`). Koszt utrzymania ≈ 0 poza kontami deweloperskimi. Brak synchronizacji między urządzeniami — eksport JSON jako jedyna kopia zapasowa.
3. **2026-11-10 — Brak paczki do zarządzania stanem.** `ChangeNotifier` + `InheritedNotifier` (`AppScope`). Wystarcza dla 6 ekranów.
4. **2026-11-10 — Konwencja numerologiczna `pl-pyth-1`.** Opis: `docs/numerology-method.md`. Wyniki zapisane w dzienniku niosą `version` algorytmu i `contentVersion`, ślad obliczenia jest zamrożony w wpisie.
5. **2026-11-10 — Tasowanie:** `List.shuffle` (Fisher–Yates) z wstrzykiwanym `Random`; w produkcji `Random.secure()`. Bez zwracania kart w obrębie rozkładu. Odwrócenia domyślnie wyłączone; po włączeniu każda karta niezależnie z p = 1/2. Test chi-kwadrat jednorodności w `test/tarot_test.dart`.
6. **2026-11-10 — Karta dnia** zapisywana z kluczem lokalnej daty urządzenia. Ten sam dzień → ta sama karta po restarcie. Nowa lokalna data (północ albo podróż do innej strefy, która zmienia datę) → nowa karta. Zmiana strefy bez zmiany daty nie zmienia karty.
7. **2026-11-10 — Brak grafik kart w MVP.** Typograficzny awers (numer, symbol koloru, nazwa). Grafiki RWS 1909 dopiero po weryfikacji konkretnych plików wg `docs/research/rws-rights.md`. Nie używamy nazw „Rider”, „Waite” w nazwie aplikacji/talii/ASO.
8. **2026-11-10 — Treści generowane w JSON** (`assets/content/`), pisane autorsko na potrzeby projektu (z pomocą modelu AI — patrz `docs/content-sources.md`). Wymagają korekty językowej człowieka przed publikacją.
9. **2026-11-10 — Lokalizacja:** napisy UI w ARB (`lib/l10n/app_pl.arb`, gen-l10n). Znane ograniczenie: teksty śladu obliczeń w silniku i nazwy rozkładów są po polsku w kodzie — przeniesienie do ARB przy dodawaniu angielskiego.
10. **2026-11-10 — Reklamy i Pro odłożone do etapu 2.** Wymagają kont AdMob / App Store Connect / Play Console, CMP (UMP, TCF), ATT na iOS. MVP nie zawiera atrap płatności — ekran Ustawień uczciwie mówi „niedostępne”.
11. **2026-11-10 — Przypomnienia odłożone do etapu 2** (wymagają `flutter_local_notifications` i uprawnień). Założenia: domyślnie wyłączone, neutralny tekst na ekranie blokady.
