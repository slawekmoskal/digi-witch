# Źródła treści i status praw

| Materiał | Plik | Pochodzenie | Status |
|---|---|---|---|
| Opisy 78 kart (symbolika, interpretacje, pytania) | `assets/content/tarot_part_a.json`, `tarot_part_b.json` | Teksty autorskie napisane dla projektu z pomocą modelu AI (Claude) na podstawie ogólnej wiedzy o symbolice talii z 1909 r.; polecenie wprost zakazywało kopiowania i parafrazowania książek (w tym Waite 1910) i współczesnych autorów | Do korekty językowej i merytorycznej (opisy obrazów pisane z pamięci — porównać ze skanami) |
| Rady kart, horoskop, Księżyc, liczba dnia/relacji, artykuł o powtarzających się liczbach, korespondencje | `advice*` w kartach, `astro.json`, `numerology.json`, `articles.json` | Teksty autorskie (z pomocą AI); korespondencje astrologiczne wg systemu Złotego Brzasku (XIX w.) | Do korekty; sprawdzić ton („Uważaj na…”) pod kątem App Store 4.3 |
| Interpretacje liczb (6 wskaźników) | `numerology.json` | jw. | Do korekty |
| 12 archetypów | `archetypes.json` | Opisy autorskie; nie kopiują opisów Mark & Pearson ani innych. Sam podział na 12 nawiązuje do układu spopularyzowanego przez Pearson i Mark — aplikacja mówi to wprost (`archetypesNote`, 2026-11-15) | Do korekty |
| 33 pytania do dziennika (14 rodzinnych) | `journal_prompts.json` | jw. | Do korekty |
| Słownik (26 pojęć), 5 artykułów | `glossary.json`, `articles.json` | jw.; źródła bibliograficzne na końcu artykułów | Zweryfikować daty Balliett/Jordan oraz godziny 116 123 (116sos.pl) |
| Grafiki kart (78) | `assets/cards/*.webp`, `assets/cards/manifest.json` | Pamela Colman Smith, talia 1909 „Roses & Lilies”, skan Saskia Jansen, Wikimedia Commons (kategoria RWS1909) | Public domain (PD-old-70, PD-US); SHA-1 każdego pliku zgodne z Commons (rewizje z 15.04.2024); przeskalowane 600 px WebP. Do zrobienia przed publikacją: ręczny przegląd stron plików (tagi, brak „© 1971”) |
| Ikony | Material Icons (Flutter SDK) | Apache 2.0 | OK |
| I Ching (64 heksagramy, 384 linie) | `iching.json` | Teksty autorskie (z pomocą AI), nie tłumaczenie. Angielskie nazwy heksagramów są własne od 2026-11-15 (wcześniej zbliżone do przekładu Wilhelma/Baynes). Nazwy w pozostałych językach nie były porównywane z wydanymi przekładami | Niskie ryzyko; do rozważenia przegląd nazw w pozostałych językach |
| Sennik (144 symbole), odczyt dnia, dodatki do numerologii | `dreams.json`, `daily.json`, `numerology_extra.json` | Teksty autorskie (z pomocą AI) | Do korekty |
| Czcionka Cormorant Garamond | `assets/fonts/` | SIL Open Font License; licencja w paczce i na ekranie licencji | OK |
| Biblioteki | `pubspec.yaml` | BSD / MIT / Apache; `dbus` (MPL 2.0) tylko dla Linuksa; brak GPL | OK; ekran licencji w Ustawieniach |
| Miasta (229) i obliczenia astronomiczne | `lib/data/places.dart`, `lib/engine/astro.dart` | Fakty (współrzędne, strefy) i wzory (Meeus, elementy JPL) — własny kod | OK |

Przegląd praw z 2026-11-12 (nie jest opinią prawną): nazwa — thedigiwitch.com nie działa i nie ma kopii w archive.org (domena zarejestrowana 2025-05-30, opłacona do 2027-05-30); działa studio marketingowe DigiWitch (digiwitch.com, inna branża). W TMview i USPTO nie ma znaku „Digi Witch” ani „DigiWitch” (sprawdzone 2026-11-12); UPRP i rejestr indyjski nie były sprawdzane osobno. Ryzyko niskie. W opisach sklepowych nie używać nazwy „Rider-Waite” jako słowa kluczowego. Strona www: przyciski sklepów to oficjalne, niezmienione plakietki Apple i Google z notą o znakach w stopce (2026-11-15, decyzja właściciela; wytyczne obu firm przewidują plakietki dla aplikacji dostępnych w sklepie — do czasu premiery to ryzyko); po publikacji podpiąć linki; dodać dane właściciela i politykę prywatności.

## Uwagi o treściach tworzonych z pomocą AI

Teksty tworzone z pomocą AI nie są automatycznie domeną publiczną ani gwarancją braku naruszeń. Przed publikacją:
1. korekta przez człowieka (najlepiej redaktor/redaktorka z wiedzą o tarocie),
2. wyrywkowe sprawdzenie wyszukiwarką kilku charakterystycznych zdań z każdego pliku, czy nie pokrywają się z istniejącymi tekstami,
3. sprawdzenie warunków używanego narzędzia AI co do praw do wyników.

## Przekaz dnia (`messages.json`) — klucz i podstawy psychologiczne

> **Nowy klucz 2026-11-14 (decyzja 55) — obowiązuje zamiast tabeli rodzajów niżej.** Właściciel podał klucz własnymi słowami: „Dobrze, że jesteś. To może być wspaniały dzień, niby zwykły, ale z nowymi możliwościami. Bądź sobą, a gwiazdy zrobią swoje.” Polskie 180 zdań napisano od nowa w tym duchu: (1) ciepłe powitanie, (2) nadzieja na dobry dzień sformułowana jako możliwość („może”, nie „będzie”), (3) „bądź sobą”, lekko, z mrugnięciem do gwiazd i Księżyca, (4) pozwolenie na zwykły, słabszy dzień, (5) ludzie, (6) małe przyjemności, (7) łagodność dla siebie. Bez poleceń, bez obietnic, język mówiony. Tylko polski jest nowy; **en/de/fr/es/uk zawierają jeszcze starsze zdania** i czekają na akceptację polskich (tłumaczyć dopiero po niej, tak jak `daily.json`). Dopóki ich nie ma, rodzaje i tabela niżej opisują tylko stare pliki.

> **Zmiana 2026-11-14 (decyzja 54).** 66 z 180 zdań (we wszystkich językach) zastąpiono zdaniami ciepłej obecności: „miło Cię widzieć”, „dobrze, że jesteś”, „Twoje drobne gesty znaczą dla ludzi więcej, niż sądzisz”, „nie musisz dziś niczego udowadniać”. Powód: właściciel uznał nakazy typu „zjedz”, „wypij”, „przejdź przystanek” za mało życzliwe. Wymiana szła po indeksach, więc **rodzaje w tabeli niżej są teraz przybliżone**: zdań „małego kroku” jest mniej niż 45, a przybyło zdań o obecności i znaczeniu (najbliżej rodzajów L i S). Wzór `messagePattern` nadal pilnuje tylko kolejności indeksów, nie treści. Dowody: Wood, Perunovic, Lee 2009 (mocne pochwały o sobie pogarszają nastrój osób z niską samooceną — dlatego zamiast „jesteś wspaniała/lepsza wersja siebie” jest „dobrze, że jesteś” i „nie musisz być lepsza”); mattering (Flett; Rosenberg, McCullough 1981: poczucie, że ma się znaczenie, chroni przed lękiem i depresją, nie jest tym samym co samoocena); Boothby, Bohns 2020 (miłe słowa cieszą odbiorców bardziej, niż przewidują nadawcy). Brak badań, które testowałyby same te zdania w aplikacji.

180 zdań na język, własnego autorstwa, w sześciu rodzajach. Rodzaj wynika z pozycji w pliku (indeks % 36, wzór `messagePattern` w `lib/engine/daily.dart`: `KLKDMCKLSDKLMCKSDKLSDKMLCKSDLKMCSDLS`), a `messageIndex` pilnuje, żeby ten sam rodzaj nie wypadał dwa dni z rzędu. Proporcje idą za siłą dowodów: najwięcej zdań o działaniu, najmniej ogólnych pochwał.

| Litera | Rodzaj | Zdań | Co robi (mechanizm) | Podstawa |
|---|---|---|---|---|
| K | Mały krok | 45 | jedno drobne działanie dziś | aktywizacja behawioralna: Cuijpers i in. 2007 (0,87 w depresji); Mazzucchelli i in. 2010 (0,52 dla dobrostanu) |
| L | Ludzie | 35 | bliskość, życzliwy gest | Curry i in. 2018 (akty życzliwości, d ≈ 0,28) |
| S | Życzliwość dla siebie | 30 | łagodny stosunek do siebie zamiast pompowania samooceny | Leary i in. 2007; Ferrari i in. 2019 (27 badań z randomizacją) |
| D | Dostrzeganie dobra | 30 | wdzięczność, smakowanie chwili; średnio co 6 dni | Emmons, McCullough 2003; Seligman i in. 2005; Cregg, Cheavens 2021 (efekt mały, g ≈ 0,29) |
| M | Mocne strony | 20 | poczucie kompetencji; tylko konkretne, bez ogólnych pochwał | Seligman i in. 2005; Cohen, Sherman 2014; Wood i in. 2009 |
| C | Ciekawość i nadzieja | 20 | własny wybór, nowość, nadzieja jako krok | model pozytywnych aktywności (zaspokojenie potrzeb) |

**Trzy dobre rzeczy.** W niedzielę pod przekazem na Dziś jest przycisk „Zapisz trzy dobre rzeczy” (wpis w Dzienniku z gotowym początkiem). Zapisanie trzech dobrych rzeczy i ich przyczyn to ćwiczenie wdzięczności z najlepszymi dowodami (Seligman i in. 2005); raz w tygodniu, bo częściej działało gorzej (Lyubomirsky, Sheldon, Schkade 2005).

Klucz pochodzi z modelu pozytywnych aktywności (Lyubomirsky, Layous 2013, *Current Directions in Psychological Science*): proste aktywności poprawiają dobrostan przez pozytywne emocje, myśli, zachowania i zaspokojenie potrzeb (autonomia, kompetencja, bliskość). Z tego samego źródła i badań pokrewnych wynikają zasady:

- **Różnorodność.** Te same aktywności powtarzane tracą działanie (przyzwyczajenie); różne działają lepiej (Sheldon i in. 2012). Liczenie dobrych rzeczy raz w tygodniu działało lepiej niż trzy razy (Lyubomirsky, Sheldon, Schkade 2005). Stąd rotacja rodzajów i brak powtórek przez pół roku.
- **Wiarygodność i konkret.** Ogólne, zawyżone stwierdzenia („jestem osobą godną miłości”) pogarszały nastrój osób z niską samooceną; lepiej działają konkretne i trudne do podważenia (Wood, Perunovic, Lee 2009, *Psychological Science* 20).
- **Zaproszenie, nie nakaz.** Język „musisz/powinieneś” wywołuje opór; język wspierający autonomię zwykle go zmniejsza, choć wyniki są mieszane. Zdania nie pytają i nie zadają pracy domowej.
- **Nadzieja jako sprawczość**, nie obietnica — zgodnie z zasadą aplikacji, że nie przepowiada przyszłości.
- **Bez zaprzeczania trudnym uczuciom.**

Najbliższy naszemu zastosowaniu dowód: codzienne wspierające SMS-y pisane przez terapeutów poznawczo-behawioralnych (dwa dziennie przez 90 dni, bez powtórek) obniżyły nasilenie depresji w małym badaniu z randomizacją (Agyapong i in. 2017, *BMC Psychiatry*; 73 osoby, d ≈ 0,67; autorzy zalecają ostrożność do czasu powtórzenia).

Efekty pojedynczych interwencji są w metaanalizach małe do umiarkowanych (Sin, Lyubomirsky 2009; Bolier i in. 2013) — to wsparcie nastroju, nie terapia. Pełny tekst przeczytano tylko dla Lyubomirsky, Layous 2013 i Agyapong i in. 2017; reszta ze streszczeń. Przydział zdań do rodzajów jest oceną autora — listę warto dać do oceny psychologowi przed publikacją.
