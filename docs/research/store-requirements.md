# Wymagania sklepów i prawa UE/PL dla aplikacji (numerologia, tarot, archetypy, dziennik)

Stan na 2026-11-10. Wszystkie źródła odczytano 2026-11-10, chyba że zaznaczono inaczej.
To jest notatka badawcza, nie porada prawna. Przed publikacją sprawdź ponownie strony źródłowe, bo zmieniają się bez zapowiedzi.
Cytaty w języku angielskim pochodzą ze stron źródłowych. Oznaczenie **NIEZWERYFIKOWANE** znaczy, że nie udało się tego potwierdzić w źródle pierwotnym.

Założenia produktu: aplikacja we Flutterze na Androida i iOS, po polsku, dla dorosłych, bez konta, offline-first, bez czatu AI. Zarabia na reklamach AdMob i jednorazowym zakupie „Pro” w aplikacji.

---

## 1. Apple — App Store Review Guidelines

Źródło: https://developer.apple.com/app-store/review/guidelines/ (odczyt 2026-11-10; na stronie nie udało się odczytać daty ostatniej aktualizacji).

### 4.3 Spam (najważniejsze ryzyko dla iOS)

- **4.3(a)**: „Don't create multiple Bundle IDs of the same app …” Wniosek: jedna aplikacja. Żadnych osobnych aplikacji „Tarot”, „Numerologia” i „Archetypy”.
- **4.3(b)**, dosłownie:
  > „Don't submit apps that are indistinguishable from what's already widely available. Opportunistically creating variants of existing app categories or popular apps degrades App Store discovery, reduces overall app quality, and harms both users and developers. Certain kinds of apps, such as dating, flashlight, sound effects, wallpaper, simple timers, and fortune telling, are well established on the App Store and we will not accept new submissions unless they offer a meaningfully different or improved experience. We may remove these apps from the App Store going forward if they are not updated, improved, or do not attract customers. […]”
- Kategoria „fortune telling” jest wymieniona wprost. Astrologia nie pojawia się w tekście 4.3. Aplikacja z wróżeniem może przejść review tylko jako „meaningfully different or improved experience”.
- **Co robimy:**
  - Pozycjonujemy aplikację jako narzędzie do nauki symboliki i refleksji, a nie do wróżenia.
  - W opisie, na zrzutach ekranu i w notatkach dla recenzenta (App Review Notes) eksponujemy wyróżniki: obliczenia pokazane krok po kroku, jawne konwencje, źródła treści, lekcje i prywatny dziennik.
  - W notatkach dla recenzenta wprost wyjaśniamy, czym aplikacja różni się od typowych „fortune telling” apps.

### 1.x — bezpieczeństwo i treść

- **1.1.6**: „False information and features, including inaccurate device data or trick/joke functionality …” Nie obiecujemy przewidywania przyszłości jako faktu. Dodajemy disclaimer „do refleksji i rozrywki”.
- **1.4.1**: „Medical apps that could provide inaccurate data or information … may be reviewed with greater scrutiny.” Nie formułujemy żadnych porad zdrowotnych, finansowych ani prawnych.
- **1.5**: „People need to know how to reach you with questions and support issues.” Potrzebny URL wsparcia i działający e-mail.
- **4.2** (minimalna funkcjonalność): „… elevate it beyond a repackaged website.”

### 3.1.1 In-App Purchase

> „If you want to unlock features or functionality within your app, (by way of example: subscriptions, in-game currencies, game levels, access to premium content, or unlocking a full version), you must use in-app purchase. Apps may not use their own mechanisms to unlock content or functionality, such as license keys …”

„Pro” musi być produktem IAP typu **non-consumable**, z przyciskiem „Przywróć zakupy” (restore). Nie stosujemy kodów ani kluczy licencyjnych.

### 5.1.1 / 5.1.2 Prywatność

- **5.1.1(i)**: link do polityki prywatności musi być w metadanych App Store Connect **i** w aplikacji. Polityka opisuje, jakie dane są zbierane, jak i w jakim celu, okres przechowywania oraz sposób usuwania danych i wycofania zgody.
- **5.1.1(ii)**: zgoda jest potrzebna nawet przy danych anonimowych. Płatne funkcje nie mogą zależeć od udzielenia zgody, a zgodę musi dać się łatwo wycofać. Wniosek: „Pro” działa tak samo bez względu na zgodę reklamową.
- **5.1.1(v)**: „If your app doesn't include significant account-based features, let people use it without a login.” Wymóg jest spełniony, bo aplikacja nie ma konta.
- **5.1.2(i)**: „You must receive explicit permission from users via the App Tracking Transparency APIs to track their activity.”

### Privacy manifest i required-reason APIs

Źródła: https://developer.apple.com/documentation/bundleresources/privacy-manifest-files oraz https://developer.apple.com/documentation/bundleresources/describing-use-of-required-reason-api (strony renderowane przez JS, treść **nie została odczytana**).

- Plik `PrivacyInfo.xcprivacy` zawiera klucze `NSPrivacyTracking`, `NSPrivacyTrackingDomains`, `NSPrivacyCollectedDataTypes` i `NSPrivacyAccessedAPITypes`.
- Kategorie required-reason API: UserDefaults (np. kod `CA92.1`), file timestamp, system boot time, disk space i active keyboard.
- Egzekwowanie od 1 maja 2024. Zewnętrzne SDK, w tym Google Mobile Ads, dostarczają własne, podpisane manifesty.
- Status: wszystkie trzy punkty powyżej są **NIEZWERYFIKOWANE** (z wiedzy ogólnej). Do sprawdzenia w dokumentacji.
- Praktycznie: `shared_preferences` we Flutterze korzysta z UserDefaults, więc deklarujemy `CA92.1`. Pozostałe kategorie sprawdzamy w raporcie Xcode „Privacy Report”.

### App Privacy („etykiety żywieniowe”)

Źródło: https://developer.apple.com/app-store/app-privacy-details/

- Deklarujemy dane zbierane przez nas **i przez SDK partnerów**: „analytics tools, advertising networks, third-party SDKs”.
- Dane osobowe w rozumieniu przepisów o ochronie prywatności traktuje się jako „linked to the user”.
- Przy AdMob deklarujemy co najmniej: Identifiers (Device ID), Usage Data (Product Interaction, Advertising Data), Diagnostics i Coarse Location (IP). Cel: Third-Party Advertising. Dokładną listę bierzemy z dokumentacji Google dla danej wersji SDK (**NIEZWERYFIKOWANE**).
- Dziennik, data urodzenia i imię zostają na urządzeniu. Danych, które nie opuszczają urządzenia, nie deklarujemy jako „collected”.

### ATT (App Tracking Transparency) przy AdMob

Źródło: https://developer.apple.com/app-store/user-privacy-and-data-use/

- „Tracking” oznacza łączenie danych z aplikacji z danymi innych firm „for targeted advertising or advertising measurement purposes”.
- ATT jest wymagane „to track them or access their device's advertising identifier”. Wymóg obejmuje też SDK, które śledzi „even if you don't use the SDK for those purposes”.
- Spersonalizowane reklamy AdMob oznaczają tracking, więc potrzebujemy klucza `NSUserTrackingUsageDescription` i promptu ATT.
- Kolejność w EOG: najpierw formularz UMP/TCF, potem ATT. UMP może pokazać własny „IDFA explainer”, co odnotowała dokumentacja AdMob, ale strona Flutter tego nie opisuje (**NIEZWERYFIKOWANE**).

### Age rating (nowy system Apple)

Źródła:
- https://developer.apple.com/help/app-store-connect/reference/app-information/age-ratings-values-and-definitions
- https://developer.apple.com/news/?id=ks775ehf (komunikat z lipca 2025)

- Obecne poziomy: **4+, 9+, 13+, 16+, 18+**. Poziomy 12+ i 17+ zniknęły.
- Termin wypełnienia nowego kwestionariusza minął 31 stycznia 2026 (źródła wtórne: macrumors.com, 9to5mac.com).
- Kategorie kwestionariusza:
  - In-App Controls
  - Capabilities (m.in. **Advertising**, User-Generated Content, Messaging)
  - Mature Themes
  - Medical or Wellness (m.in. **Health or Wellness Topics**)
  - Sexuality or Nudity
  - Violence
  - Chance-Based Activities
- Kwestionariusz **nie ma osobnej kategorii „fortune telling”/astrologia**. Na odczytanej części strony nie występuje ten termin, a fragmentu o Korei nie udało się odczytać.
- Konkurencja dostaje różne oceny: Labyrinthos 13+ (z „Health or Wellness Topics”), „Horoskop i Tarot” 9+ (Horror/Fear), Co–Star 4+.
- Rekomendacja: odpowiadamy uczciwie i zaznaczamy Advertising. Rozważamy ręczne podniesienie do **16+ lub 18+**, bo celujemy w dorosłych. Apple pozwala ustawić wyższy wiek minimalny. To wzmacnia też stanowisko, że aplikacja „nie jest dla dzieci” wobec Google Families.

---

## 2. Google Play

| Temat | Wymóg (cytat lub streszczenie) | Źródło |
|---|---|---|
| **Target API** | „New apps and app updates must target **Android 16 (API level 36)** or higher”. Termin 31 sierpnia 2026, możliwe przedłużenie do 1 listopada 2026, które już minęło. | https://support.google.com/googleplay/android-developer/answer/11926878 |
| **Testy zamknięte (konto osobiste)** | Konta osobiste założone po 13 listopada 2023 muszą „run a closed test … with a minimum of **12 testers** … opted in continuously for at least **14 days**” przed dostępem do produkcji. | https://support.google.com/googleplay/android-developer/answer/14151465 |
| **Data safety** | Formularz jest obowiązkowy nawet przy braku zbierania danych. „Collect” to „transmitting data from your app off a user's device”. Dane wysyłane przez SDK, np. reklamowe, liczą się jako nasze. Dane przetwarzane wyłącznie lokalnie nie podlegają deklaracji. Przy AdMob deklarujemy m.in. Device or other IDs, App interactions, Diagnostics i Approximate location jako *shared* i *collected* w celu Advertising (lista do potwierdzenia w dokumentacji AdMob, **NIEZWERYFIKOWANE**). | https://support.google.com/googleplay/android-developer/answer/10787469 |
| **Families / grupa docelowa** | W „Target audience and content” zaznaczamy wyłącznie **18+**. Google może zakwestionować deklarację, jeśli grafika lub język „could be considered targeting children”. Wymogi Families (m.in. „Families Self-Certified Ads SDKs”) dotyczą tylko aplikacji z dziećmi w grupie docelowej. Wniosek: dojrzała, niekreskówkowa estetyka. | https://support.google.com/googleplay/android-developer/answer/9893335 |
| **Ads policy** | Reklama nie może zmuszać do kliknięcia. Reklamy zakłócające korzystanie mają być „easily dismissible”. Pełnoekranowe interstitiale „that show unexpectedly … are not allowed”, a te „not closeable after 15 seconds are not allowed”. Zakaz reklam na ekranie blokady. Rekomendacja: banner i ewentualnie opcjonalny rewarded. Bez interstitiala w trakcie rozkładu kart i pisania w dzienniku. | https://support.google.com/googleplay/android-developer/answer/9857753 |
| **IARC** | „You must complete the content rating questionnaire for each new app”. Aplikacje bez oceny są usuwane. | https://support.google.com/googleplay/android-developer/answer/9898843 |
| **Play Billing** | Treści i funkcje cyfrowe „must use Google Play's billing system”. Pro kupujemy jako produkt jednorazowy (in-app product, nie subskrypcja). Alternatywny billing tylko w programach dla „eligible countries/regions”, czego nie dotyczymy. | https://support.google.com/googleplay/android-developer/answer/9858738 |
| **Ogłoszenie polityk z 29.10.2026** | Co najmniej 30 dni na dostosowanie. Od listopada 2026 obowiązuje deklaracja trader status. Zapowiedziane wymogi jakości (pamięć i kod) z terminem w lutym 2027. Zmiany w uprawnieniach lokalizacji (od 27.01.2027) nas nie dotyczą, bo nie prosimy o lokalizację. | https://support.google.com/googleplay/android-developer/answer/18100766?hl=en-GB |

---

## 3. UE / Polska

### Zgoda RODO na reklamy (CMP / TCF)

- Źródło: https://support.google.com/admob/answer/13554116
  - Cytat: „a certified CMP integrated with the TCF is required when serving personalized ads to users in the EEA and UK”.
  - Obowiązuje od 16 stycznia 2024.
- Implementacja (https://developers.google.com/admob/flutter/privacy):
  1. Komunikat GDPR konfigurujemy w AdMob → Privacy & messaging.
  2. Przy **każdym** starcie wywołujemy `ConsentInformation.instance.requestConsentInfoUpdate()`, a potem `ConsentForm.loadAndShowConsentFormIfRequired()`.
  3. Przed każdym żądaniem reklamy sprawdzamy `canRequestAds()`.
  4. Gdy `getPrivacyOptionsRequirementStatus()` zwraca „required”, w Ustawieniach musi być stały punkt „Ustawienia prywatności”, który wywołuje `showPrivacyOptionsForm()`.
- Do sprawdzenia: wytyczne UODO i EROD dotyczące cookie walls i „pay or ok”. Nie wiążemy Pro z odmową zgody wprost jako „zapłać albo zgódź się” bez analizy prawnej. Źródło https://uodo.gov.pl nie zostało sprawdzone w tej rundzie (**NIEZWERYFIKOWANE**).

### DSA — status przedsiębiorcy (trader)

- **Apple** (https://developer.apple.com/help/app-store-connect/manage-compliance-information/manage-european-union-digital-services-act-trader-requirements):
  - Deklaracja jest obowiązkowa.
  - Osoba fizyczna-trader podaje adres (lub skrytkę pocztową), telefon i e-mail. Dane są wyświetlane na stronie produktu w UE.
  - Non-trader: konsumenci zostaną poinformowani, że ochrona konsumencka ich nie dotyczy.
- **Google** (https://support.google.com/googleplay/android-developer/answer/17594752?hl=en-GB):
  - Nowe konta deklarują status przy zakładaniu, istniejące do **1 lutego 2027**.
  - Publiczne wyświetlanie danych (dla konta osobistego „a phone number and address”) rusza od **1 marca 2027**.
  - Fałszywe deklarowanie się jako non-trader grozi „global removal”.
- Wniosek: aplikacja z reklamami i IAP to działalność komercyjna, więc realnie trzeba deklarować się jako **trader**.
- Konsekwencja: **adres i telefon będą publiczne**. Rozważyć adres do doręczeń lub wirtualne biuro. Skrytka pocztowa u Google może nie przejść weryfikacji (źródło wtórne). To decyzja właściciela.

### Prawo odstąpienia od umowy (treści cyfrowe)

- Dyrektywa 2011/83/UE (https://eur-lex.europa.eu/legal-content/PL/TXT/?uri=CELEX:32011L0083), art. 16 lit. m: wyjątek dla „dostarczania treści cyfrowych, które nie są dostarczane na trwałym nośniku”, „jeżeli spełnienie świadczenia rozpoczęło się za uprzednią wyraźną zgodą konsumenta” i po przyjęciu przez niego do wiadomości, że traci prawo odstąpienia. Art. 8 ust. 7 lit. b wymaga potwierdzenia tej zgody.
- W Polsce odpowiednikiem jest art. 38 ustawy o prawach konsumenta (numer punktu po nowelizacji z 2023 r. **NIEZWERYFIKOWANE**).
- Przy zakupie przez Apple lub Google stroną sprzedaży jest sklep, który obsługuje zgody i zwroty. Przy statusie trader nasze obowiązki konsumenckie wobec treści i zgodności cyfrowej i tak istnieją. Szczegóły podziału ról są **NIEZWERYFIKOWANE**.
- W regulaminie i w ekranie Pro dodajemy jasną informację o zakresie i cenie.

---

## 4. Checklista

| Wymaganie | Co robimy w aplikacji | Status |
|---|---|---|
| Apple 4.3(b) fortune telling | Pozycjonowanie „nauka i refleksja”, wyróżniki na zrzutach ekranu, App Review Notes | do zrobienia (ryzyko odrzucenia) |
| Apple 4.3(a) jedna aplikacja | Jeden bundle ID dla wszystkich modułów | zaplanowane |
| Apple 1.1.6 / 1.4.1 | Disclaimer „nie przepowiada przyszłości, nie jest poradą” | do zrobienia |
| Apple 1.5 / polityka prywatności | Strona WWW z polityką i e-mailem wsparcia, link w aplikacji i w metadanych | do zrobienia |
| Apple 3.1.1 / Play Billing | Pro jako non-consumable IAP (np. pakiet `in_app_purchase`), przycisk przywracania zakupów | do zrobienia |
| Apple 5.1.1(ii) | Pro działa niezależnie od zgody reklamowej, zgodę można wycofać w Ustawieniach | do zrobienia |
| Apple 5.1.1(v) | Bez konta | spełnione z założenia |
| Privacy manifest | `PrivacyInfo.xcprivacy` z UserDefaults `CA92.1`, weryfikacja Privacy Report | do zrobienia, NIEZWERYFIKOWANE szczegóły |
| App Privacy labels | Deklaracja danych AdMob, dane dziennika bez deklaracji (zostają na urządzeniu) | do zrobienia |
| ATT | `NSUserTrackingUsageDescription` po polsku, prompt po UMP | do zrobienia |
| Apple age rating | Uczciwy kwestionariusz, zaznaczone Advertising, rozważyć ręczne 16+/18+ | do decyzji |
| Google target API 36 | `targetSdkVersion 36` w Gradle | do zrobienia |
| 12 testerów / 14 dni | Zebrać 12+ testerów, test zamknięty min. 14 dni przed produkcją | do zaplanowania (blokuje premierę o ≥2 tyg.) |
| Data safety | Formularz z danymi SDK AdMob | do zrobienia |
| Families | Target audience tylko 18+, dojrzała grafika | do zrobienia |
| Ads policy | Banner i opcjonalny rewarded, bez nieoczekiwanych interstitiali | zaplanowane |
| IARC | Kwestionariusz w Play Console | do zrobienia |
| CMP / TCF (EOG) | UMP SDK: `requestConsentInfoUpdate` przy starcie, `canRequestAds`, wpis „Ustawienia prywatności” | do zrobienia |
| DSA trader (Apple i Google) | Deklaracja trader, decyzja o publicznym adresie i telefonie | do decyzji właściciela (blokujące) |
| Prawo odstąpienia | Informacja na ekranie Pro i w regulaminie | do zrobienia, do konsultacji prawnej |
