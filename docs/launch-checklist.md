# Lista startowa — kroki właściciela

Kod jest gotowy na te ustawienia. Wszystko poniżej wymaga Twoich kont, zgód lub decyzji. Kolejność ma znaczenie.

## 0. Decyzje prawne (blokujące publikację)

- [ ] **Status przedsiębiorcy (DSA)** w obu sklepach. Przy reklamach i IAP realnie jesteś „trader”. Sklepy **publicznie pokażą** adres, telefon i e-mail (Google od 1.03.2027, Apple od razu). Rozważ adres firmy lub biura wirtualnego.
- [ ] **Polityka prywatności**: gotowa strona `site/prywatnosc/index.html` (PL + EN, administrator wpisany) — wgraj `site/` na serwer, żeby działał adres `https://digi-witch.com/prywatnosc/` (ten sam link jest w Ustawieniach aplikacji). Bez konsultacji prawnej.
- [ ] **E-mail pomocy**, np. `pomoc@digi-witch.com` (wpisać też do `helpBody` w `lib/l10n/app_pl.arb`).
- [ ] Korekta językowa treści (`assets/content/*.json`) przez człowieka; porównanie opisów obrazów ze skanami.

## 1. Konta

- [ ] Apple Developer Program (99 USD/rok).
- [ ] Google Play Console (25 USD jednorazowo). Przy koncie **osobistym**: test zamknięty z ≥12 testerami przez ≥14 dni przed produkcją. Konto **firmowe** (D-U-N-S) tego nie wymaga.
- [ ] AdMob (bezpłatne), połączone z oboma sklepami po publikacji.

## 2. AdMob

1. Utwórz 2 aplikacje (Android `com.digiwitch.app`, iOS `com.digiwitch.app`) i po 1 jednostce **Banner** w każdej.
2. **Privacy & messaging**: komunikat GDPR (TCF, certyfikowany CMP Google) dla EOG/UK, język polski; dla iOS dodatkowo **IDFA explainer** (UMP pokaże go przed systemowym ATT).
3. Ustawienia blokowania: kategorie wrażliwe (hazard, randki, polityka, religia, tematy „ezoteryczne paid services” — według uznania), max rating „T”.
4. Podmień identyfikatory przy buildzie:
   ```
   flutter build appbundle --release \
     -PADMOB_APP_ID_ANDROID=ca-app-pub-XXX~YYY \
     --dart-define=ADMOB_BANNER_ANDROID=ca-app-pub-XXX/ZZZ
   flutter build ipa --release --dart-define=ADMOB_BANNER_IOS=ca-app-pub-XXX/WWW
   ```
   iOS App ID: zamień `GADApplicationIdentifier` w `ios/Runner/Info.plist` (teraz testowy Google).
5. `app-ads.txt` na `https://digi-witch.com/app-ads.txt` (AdMob poda treść).

## 3. Produkt Pro

- [ ] App Store Connect → In-App Purchases → **Non-Consumable**, Product ID `pro_lifetime`, cena 24,99 zł (najbliższy próg cenowy).
- [ ] Play Console → Produkty → **Produkt jednorazowy** `pro_lifetime`, 24,99 zł.
- [ ] Zrzut ekranu arkusza Pro do recenzji Apple.
- Testy zakupu: Apple Sandbox tester (StoreKit), Google License testers. **Nieprzetestowane do tej pory — wymaga kont.**

## 4. Podpisywanie

- [ ] Android: utwórz upload keystore (`keytool -genkey -v -keystore ~/digiwitch-upload.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload`), `android/key.properties`, konfiguracja `signingConfigs` (teraz release podpisany kluczem debug). Włącz Play App Signing. **Klucza nie commituj.**
- [ ] iOS: zespół w Xcode (Runner → Signing & Capabilities), capability **In-App Purchase**.

## 5. Formularze sklepów (odpowiedzi do wklejenia)

**Google Play — Data safety** (zweryfikuj z aktualną dokumentacją Google Mobile Ads SDK):
- Dane zbierane przez SDK AdMob: identyfikator urządzenia/reklamowy, dane o interakcjach z aplikacją, diagnostyka, przybliżona lokalizacja (z IP). Cel: reklamy, analityka, zapobieganie oszustwom. Szyfrowane w transmisji.
- Dane wpisywane przez użytkownika (data urodzenia, imię, dziennik): **nie są zbierane** (zostają na urządzeniu, nie są przesyłane).
- Zakupy: obsługiwane przez Google Play.
- Usunięcie danych: w aplikacji, Ustawienia → Usuń wszystkie dane.

**Google Play — Grupa docelowa:** tylko 18+. Treści: nie dla dzieci. Reklamy: tak.

**Apple — App Privacy:** Identifiers (Device ID) — Third-Party Advertising, Used for Tracking (jeśli ATT zgoda); Usage Data; Diagnostics; Coarse Location — wg dokumentacji Google. Brak danych powiązanych z tożsamością przez nas.

**Apple — Age rating:** odpowiedz uczciwie (Advertising: tak). Rekomendacja produktu: ręcznie podnieś do **16+ lub 18+** (decyzja produktowa, nie wymóg prawny).

**Privacy manifest iOS:** przy archiwizacji wygeneruj Privacy Report (Xcode → Organizer → Generate Privacy Report) i sprawdź, czy wtyczki (shared_preferences, AdMob, UMP) dostarczają swoje manifesty. Jeśli raport pokaże brak dla kodu aplikacji — dodaj `PrivacyInfo.xcprivacy` z `NSPrivacyAccessedAPICategoryUserDefaults` / `CA92.1`. **Nie zweryfikowano.**

## 6. Zawartość karty sklepu

- Nazwa: „Digi Witch — liczby i tarot” (bez „Rider”, „Waite”).
- Kategoria: Styl życia (Lifestyle) / Rozrywka. Opis i zrzuty eksponujące: kroki obliczeń, bibliotekę, dziennik — zgodnie z `docs/review-notes.md`.
- Dystrybucja: **tylko Polska** w pierwszym wydaniu.
