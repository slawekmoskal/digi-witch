# Decyzje projektowe (ADR-lite)

Format: data — decyzja — dlaczego — konsekwencje. Najnowsze na dole.

1. **2026-11-10 — Flutter (stable 3.x, Dart 3.13).** Prompt wskazuje Flutter; właściciel potwierdził wybór wobec React Native. Jeden kod, własny UI, testy logiki/widgetów bez urządzenia, oficjalne pluginy AdMob/UMP i IAP.
2. **2026-11-10 — Brak backendu i konta.** Wszystko lokalnie (`shared_preferences`). Koszt utrzymania ≈ 0 poza kontami deweloperskimi. Brak synchronizacji między urządzeniami — eksport JSON jako jedyna kopia zapasowa.
3. **2026-11-10 — Brak paczki do zarządzania stanem.** `ChangeNotifier` + `InheritedNotifier` (`AppScope`). Wystarcza dla 6 ekranów.
4. **2026-11-10 — Konwencja numerologiczna `pl-pyth-1`.** Opis: `docs/numerology-method.md`. Wyniki zapisane w dzienniku niosą `version` algorytmu i `contentVersion`, ślad obliczenia jest zamrożony w wpisie.
5. **2026-11-10 — Tasowanie:** `List.shuffle` (Fisher–Yates) z wstrzykiwanym `Random`; w produkcji `Random.secure()`. Bez zwracania kart w obrębie rozkładu. Odwrócenia domyślnie wyłączone; po włączeniu każda karta niezależnie z p = 1/2. Test chi-kwadrat jednorodności w `test/tarot_test.dart`.
6. **2026-11-10 — Karta dnia** zapisywana z kluczem lokalnej daty urządzenia. Ten sam dzień → ta sama karta po restarcie. Nowa lokalna data (północ albo podróż do innej strefy, która zmienia datę) → nowa karta. Zmiana strefy bez zmiany daty nie zmienia karty.
7. ~~Brak grafik kart w MVP~~ (zastąpione przez 15; typograficzny awers zostaje jako fallback). Typograficzny awers (numer, symbol koloru, nazwa). Grafiki RWS 1909 dopiero po weryfikacji konkretnych plików wg `docs/research/rws-rights.md`. Nie używamy nazw „Rider”, „Waite” w nazwie aplikacji/talii/ASO.
8. **2026-11-10 — Treści generowane w JSON** (`assets/content/`), pisane autorsko na potrzeby projektu (z pomocą modelu AI — patrz `docs/content-sources.md`). Wymagają korekty językowej człowieka przed publikacją.
9. **2026-11-10 — Lokalizacja:** napisy UI w ARB (`lib/l10n/app_pl.arb`, gen-l10n). Znane ograniczenie: teksty śladu obliczeń w silniku i nazwy rozkładów są po polsku w kodzie — przeniesienie do ARB przy dodawaniu angielskiego.
10. ~~Reklamy i Pro odłożone do etapu 2~~ — zrealizowane, patrz 13–14.
11. ~~Przypomnienia odłożone~~ — zrealizowane, patrz 16.
12. **2026-11-10 — Identyfikator `com.digiwitch.app`, nazwa „Digi Witch”** (domena digi-witch.com; myślnik niedozwolony w pakiecie Androida).
13. **2026-11-10 — Pro = jednorazowy zakup `pro_lifetime`, 24,99 zł** (decyzja właściciela: 25 zł). Daje: brak reklam, rozkłady „Relacja” i „Krzyż refleksji”. Numerologia, karta dnia, rozkłady 1/3/5, biblioteka, grafiki i dziennik zostają darmowe. Pro zapisane lokalnie, przywracane przez „Przywróć zakupy”; brak serwerowej weryfikacji paragonów (świadomy skrót). „Usuń wszystkie dane” zachowuje Pro.
14. **2026-11-10 — Reklamy: jeden mały baner 320×50** nad paskiem nawigacji; brak reklam pełnoekranowych i nagradzanych; brak reklam w Dzienniku i dla Pro. Zgoda przez UMP (TCF) przed inicjalizacją SDK; ATT przez komunikat IDFA w UMP. `maxAdContentRating = T`. Identyfikatory testowe Google jako domyślne, prawdziwe wstrzykiwane przy buildzie.
15. **2026-11-10 — Grafiki: zestaw „Roses & Lilies” (RWS1909) z Wikimedia Commons**, 78 plików, SHA-1 zweryfikowane, przeskalowane do 600 px WebP (7,8 MB). Proweniencja per plik: `assets/cards/manifest.json`. Bez rewersów i bez późniejszych kolorowań.
16. **2026-11-10 — Przypomnienia**: `flutter_local_notifications` (wymusza `compileSdk = 37`; `targetSdk` 36), harmonogram niedokładny (bez uprawnienia exact alarm), uprawnienie systemowe pytane dopiero przy włączeniu. Tekst: „Chwila na refleksję — jeśli masz ochotę.”
17. **2026-11-10 — Kopie zapasowe Androida pozostają włączone** (domyślne): chroni dziennik przed utratą przy zmianie telefonu; kopie Google są szyfrowane. Opisane w polityce prywatności.
