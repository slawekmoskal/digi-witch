"""Adds de/fr/es/uk arguments to tr(pl:, en:) calls in Dart files.

Keys are the English Dart literals exactly as written after `en: `; values are the
de, fr, es, uk literals (same interpolations). Calls that already have `de:` are skipped,
so the script can be rerun. Usage: python3 tool/l10n/code_strings.py <repo root>
"""
import re, sys

T = {
# numerology.dart
"'Result ${seen.first} needs no reduction.'": [
 "'Das Ergebnis ${seen.first} muss nicht reduziert werden.'",
 "'Le résultat ${seen.first} n’a pas besoin d’être réduit.'",
 "'El resultado ${seen.first} no necesita reducción.'",
 "'Результат ${seen.first} не потребує зведення.'"],
"'Reduction: ${parts.join('; ')}.'": [
 "'Reduktion: ${parts.join('; ')}.'",
 "'Réduction : ${parts.join('; ')}.'",
 "'Reducción: ${parts.join('; ')}.'",
 "'Зведення: ${parts.join('; ')}.'"],
"' $v is a master number in this convention, so it is not reduced further.'": [
 "' $v ist nach der gewählten Konvention eine Meisterzahl und wird nicht weiter reduziert.'",
 "' $v est un nombre maître selon la convention retenue : on ne le réduit pas davantage.'",
 "' $v es un número maestro según la convención adoptada, así que no se reduce más.'",
 "' $v — майстер-число за прийнятою конвенцією, тому далі не зводиться.'"],
"'Sum of all digits of the full date, then reduced (11, 22 and 33 are kept).'": [
 "'Summe aller Ziffern des vollständigen Datums, dann Reduktion (11, 22 und 33 bleiben erhalten).'",
 "'Somme de tous les chiffres de la date complète, puis réduction (11, 22 et 33 sont conservés).'",
 "'Suma de todas las cifras de la fecha completa y después reducción (se conservan 11, 22 y 33).'",
 "'Сума всіх цифр повної дати, потім зведення (11, 22 і 33 зберігаємо).'"],
"'Date of birth'": ["'Geburtsdatum'", "'Date de naissance'", "'Fecha de nacimiento'", "'Дата народження'"],
"'Date digits: ${digits.join(' + ')} = $sum.'": [
 "'Ziffern des Datums: ${digits.join(' + ')} = $sum.'",
 "'Chiffres de la date : ${digits.join(' + ')} = $sum.'",
 "'Cifras de la fecha: ${digits.join(' + ')} = $sum.'",
 "'Цифри дати: ${digits.join(' + ')} = $sum.'"],
"'The day of the month alone, reduced (11 and 22 are kept).'": [
 "'Nur der Tag des Monats, reduziert (11 und 22 bleiben erhalten).'",
 "'Le jour du mois seul, réduit (11 et 22 sont conservés).'",
 "'Solo el día del mes, reducido (se conservan 11 y 22).'",
 "'Лише день місяця, зведений (11 і 22 зберігаємо).'"],
"'Day of birth'": ["'Geburtstag'", "'Jour de naissance'", "'Día de nacimiento'", "'День народження'"],
"'Sum of the digits of your birth day and month and of the chosen year, reduced to 1–9. The year starts on 1 January.'": [
 "'Summe der Ziffern von Geburtstag und -monat sowie des gewählten Jahres, reduziert auf 1–9. Das Jahr beginnt am 1. Januar.'",
 "'Somme des chiffres du jour et du mois de naissance et de l’année choisie, réduite à 1–9. L’année commence le 1er janvier.'",
 "'Suma de las cifras del día y el mes de nacimiento y del año elegido, reducida a 1–9. El año empieza el 1 de enero.'",
 "'Сума цифр дня й місяця народження та обраного року, зведена до 1–9. Рік починається 1 січня.'"],
"'Day and month'": ["'Tag und Monat'", "'Jour et mois'", "'Día y mes'", "'День і місяць'"],
"'Year'": ["'Jahr'", "'Année'", "'Año'", "'Рік'"],
"'Day: ${birth.day} → $a; month: ${birth.month} → $b; year: $year → $c.'": [
 "'Tag: ${birth.day} → $a; Monat: ${birth.month} → $b; Jahr: $year → $c.'",
 "'Jour : ${birth.day} → $a ; mois : ${birth.month} → $b ; année : $year → $c.'",
 "'Día: ${birth.day} → $a; mes: ${birth.month} → $b; año: $year → $c.'",
 "'День: ${birth.day} → $a; місяць: ${birth.month} → $b; рік: $year → $c.'"],
"'Sum: $a + $b + $c = ${a + b + c}.'": [
 "'Summe: $a + $b + $c = ${a + b + c}.'",
 "'Somme : $a + $b + $c = ${a + b + c}.'",
 "'Suma: $a + $b + $c = ${a + b + c}.'",
 "'Сума: $a + $b + $c = ${a + b + c}.'"],
"'Personal year plus the digits of the current month and day, reduced to 1–9.'": [
 "'Persönliches Jahr plus die Ziffern des aktuellen Monats und Tages, reduziert auf 1–9.'",
 "'Année personnelle plus les chiffres du mois et du jour en cours, réduite à 1–9.'",
 "'Año personal más las cifras del mes y el día actuales, reducido a 1–9.'",
 "'Особистий рік плюс цифри поточного місяця й дня, зведено до 1–9.'"],
"'Day'": ["'Tag'", "'Jour'", "'Día'", "'День'"],
"'Personal year ${day.year}: $py.'": [
 "'Persönliches Jahr ${day.year}: $py.'",
 "'Année personnelle ${day.year} : $py.'",
 "'Año personal ${day.year}: $py.'",
 "'Особистий рік ${day.year}: $py.'"],
"'Month: ${day.month} → $m; day: ${day.day} → $dd.'": [
 "'Monat: ${day.month} → $m; Tag: ${day.day} → $dd.'",
 "'Mois : ${day.month} → $m ; jour : ${day.day} → $dd.'",
 "'Mes: ${day.month} → $m; día: ${day.day} → $dd.'",
 "'Місяць: ${day.month} → $m; день: ${day.day} → $dd.'"],
"'Sum: $py + $m + $dd = ${py + m + dd}.'": [
 "'Summe: $py + $m + $dd = ${py + m + dd}.'",
 "'Somme : $py + $m + $dd = ${py + m + dd}.'",
 "'Suma: $py + $m + $dd = ${py + m + dd}.'",
 "'Сума: $py + $m + $dd = ${py + m + dd}.'"],
"'Sum of both life path numbers, reduced to 1–9.'": [
 "'Summe der Lebenszahlen beider Personen, reduziert auf 1–9.'",
 "'Somme des chemins de vie des deux personnes, réduite à 1–9.'",
 "'Suma de los caminos de vida de ambas personas, reducida a 1–9.'",
 "'Сума чисел життєвого шляху обох людей, зведена до 1–9.'"],
"'Person 1'": ["'Person 1'", "'Personne 1'", "'Persona 1'", "'Особа 1'"],
"'Person 2'": ["'Person 2'", "'Personne 2'", "'Persona 2'", "'Особа 2'"],
"'Life paths: $x + $y = ${x + y}.'": [
 "'Lebenszahlen: $x + $y = ${x + y}.'",
 "'Chemins de vie : $x + $y = ${x + y}.'",
 "'Caminos de vida: $x + $y = ${x + y}.'",
 "'Життєві шляхи: $x + $y = ${x + y}.'"],
"'As written'": ["'Schreibweise'", "'Graphie'", "'Grafía'", "'Написання'"],
"'Normalised'": ["'Nach der Normalisierung'", "'Après normalisation'", "'Tras normalizar'", "'Після нормалізації'"],
"'No letters of this group, so there is nothing to calculate.'": [
 "'Keine Buchstaben dieser Gruppe, also gibt es nichts zu berechnen.'",
 "'Aucune lettre de ce groupe : il n’y a rien à calculer.'",
 "'No hay letras de este grupo, así que no hay nada que calcular.'",
 "'Немає літер цієї групи, тож рахувати нічого.'"],
"'Letters: ${used.map((l) => '$l=${letterValue(l)}').join(', ')}.'": [
 "'Buchstaben: ${used.map((l) => '$l=${letterValue(l)}').join(', ')}.'",
 "'Lettres : ${used.map((l) => '$l=${letterValue(l)}').join(', ')}.'",
 "'Letras: ${used.map((l) => '$l=${letterValue(l)}').join(', ')}.'",
 "'Літери: ${used.map((l) => '$l=${letterValue(l)}').join(', ')}.'"],
"'Sum: $sum.'": ["'Summe: $sum.'", "'Somme : $sum.'", "'Suma: $sum.'", "'Сума: $sum.'"],
"'Sum of the values of all letters (A–Z cycling through 1–9), reduced, keeping 11, 22 and 33.'": [
 "'Summe der Werte aller Buchstaben (A–Z zyklisch 1–9), reduziert; 11, 22 und 33 bleiben erhalten.'",
 "'Somme des valeurs de toutes les lettres (A–Z de 1 à 9 en boucle), réduite ; 11, 22 et 33 sont conservés.'",
 "'Suma de los valores de todas las letras (A–Z del 1 al 9 en ciclo), reducida; se conservan 11, 22 y 33.'",
 "'Сума значень усіх літер (A–Z циклічно 1–9), зведена; 11, 22 і 33 зберігаємо.'"],
"'Sum of the values of the vowels A, E, I, O, U, Y, reduced, keeping 11, 22 and 33.'": [
 "'Summe der Werte der Vokale A, E, I, O, U, Y, reduziert; 11, 22 und 33 bleiben erhalten.'",
 "'Somme des valeurs des voyelles A, E, I, O, U, Y, réduite ; 11, 22 et 33 sont conservés.'",
 "'Suma de los valores de las vocales A, E, I, O, U, Y, reducida; se conservan 11, 22 y 33.'",
 "'Сума значень голосних A, E, I, O, U, Y, зведена; 11, 22 і 33 зберігаємо.'"],
"'Sum of the values of the consonants (letters other than A, E, I, O, U, Y), reduced, keeping 11, 22 and 33.'": [
 "'Summe der Werte der Konsonanten (alle Buchstaben außer A, E, I, O, U, Y), reduziert; 11, 22 und 33 bleiben erhalten.'",
 "'Somme des valeurs des consonnes (lettres autres que A, E, I, O, U, Y), réduite ; 11, 22 et 33 sont conservés.'",
 "'Suma de los valores de las consonantes (letras distintas de A, E, I, O, U, Y), reducida; se conservan 11, 22 y 33.'",
 "'Сума значень приголосних (літери, крім A, E, I, O, U, Y), зведена; 11, 22 і 33 зберігаємо.'"],
"'Date digits: ${dateDigits.join(' + ')} = $a (first working number).'": [
 "'Ziffern des Datums: ${dateDigits.join(' + ')} = $a (erste Arbeitszahl).'",
 "'Chiffres de la date : ${dateDigits.join(' + ')} = $a (premier nombre de travail).'",
 "'Cifras de la fecha: ${dateDigits.join(' + ')} = $a (primer número auxiliar).'",
 "'Цифри дати: ${dateDigits.join(' + ')} = $a (перше робоче число).'"],
"'Digit sum of $a = $b (second).'": [
 "'Quersumme von $a = $b (zweite).'",
 "'Somme des chiffres de $a = $b (deuxième).'",
 "'Suma de las cifras de $a = $b (segundo).'",
 "'Сума цифр $a = $b (друге).'"],
"'For births from 2000 on: $a + 19 = $c (third).'": [
 "'Für Geburten ab 2000: $a + 19 = $c (dritte).'",
 "'Pour les naissances à partir de 2000 : $a + 19 = $c (troisième).'",
 "'Para nacimientos desde el 2000: $a + 19 = $c (tercero).'",
 "'Для народжених від 2000 року: $a + 19 = $c (третє).'"],
"'$a − 2 × $firstDayDigit (first digit of the day) = $c (third).'": [
 "'$a − 2 × $firstDayDigit (erste Ziffer des Tages) = $c (dritte).'",
 "'$a − 2 × $firstDayDigit (premier chiffre du jour) = $c (troisième).'",
 "'$a − 2 × $firstDayDigit (primera cifra del día) = $c (tercero).'",
 "'$a − 2 × $firstDayDigit (перша цифра дня) = $c (третє).'"],
"'Digit sum of $c = $e (fourth).'": [
 "'Quersumme von $c = $e (vierte).'",
 "'Somme des chiffres de $c = $e (quatrième).'",
 "'Suma de las cifras de $c = $e (cuarto).'",
 "'Сума цифр $c = $e (четверте).'"],
"'The grid takes the digits of the date and of the four working numbers, without zeros.'": [
 "'In das Raster kommen die Ziffern des Datums und der vier Arbeitszahlen, ohne Nullen.'",
 "'La grille reprend les chiffres de la date et des quatre nombres de travail, sans les zéros.'",
 "'En la cuadrícula entran las cifras de la fecha y de los cuatro números auxiliares, sin ceros.'",
 "'До таблиці потрапляють цифри дати й чотирьох робочих чисел, без нулів.'"],
"'Personal year plus the digits of the month, reduced to 1–9.'": [
 "'Persönliches Jahr plus die Ziffern des Monats, reduziert auf 1–9.'",
 "'Année personnelle plus les chiffres du mois, réduite à 1–9.'",
 "'Año personal más las cifras del mes, reducido a 1–9.'",
 "'Особистий рік плюс цифри місяця, зведено до 1–9.'"],
"'Month'": ["'Monat'", "'Mois'", "'Mes'", "'Місяць'"],
"'Personal year $year: $py.'": [
 "'Persönliches Jahr $year: $py.'",
 "'Année personnelle $year : $py.'",
 "'Año personal $year: $py.'",
 "'Особистий рік $year: $py.'"],
"'Month: $month → $m.'": ["'Monat: $month → $m.'", "'Mois : $month → $m.'", "'Mes: $month → $m.'", "'Місяць: $month → $m.'"],
"'Sum: $py + $m = ${py + m}.'": [
 "'Summe: $py + $m = ${py + m}.'",
 "'Somme : $py + $m = ${py + m}.'",
 "'Suma: $py + $m = ${py + m}.'",
 "'Сума: $py + $m = ${py + m}.'"],
"'Sum of the life path and the expression number, reduced, keeping 11, 22 and 33.'": [
 "'Summe aus Lebenszahl und Ausdruckszahl, reduziert; 11, 22 und 33 bleiben erhalten.'",
 "'Somme du chemin de vie et du nombre d’expression, réduite ; 11, 22 et 33 sont conservés.'",
 "'Suma del camino de vida y del número de expresión, reducida; se conservan 11, 22 y 33.'",
 "'Сума життєвого шляху й числа вираження, зведена; 11, 22 і 33 зберігаємо.'"],
"'Life path $lp + expression $ex = ${lp + ex}.'": [
 "'Lebenszahl $lp + Ausdruckszahl $ex = ${lp + ex}.'",
 "'Chemin de vie $lp + expression $ex = ${lp + ex}.'",
 "'Camino de vida $lp + expresión $ex = ${lp + ex}.'",
 "'Життєвий шлях $lp + вираження $ex = ${lp + ex}.'"],
"'Sum of the digits (letters by the A–Z table), reduced to 1–9. Other characters are skipped.'": [
 "'Summe der Ziffern (Buchstaben nach der Tabelle A–Z), reduziert auf 1–9. Andere Zeichen werden übersprungen.'",
 "'Somme des chiffres (lettres selon la table A–Z), réduite à 1–9. Les autres caractères sont ignorés.'",
 "'Suma de las cifras (letras según la tabla A–Z), reducida a 1–9. Los demás caracteres se omiten.'",
 "'Сума цифр (літери за таблицею A–Z), зведена до 1–9. Інші символи пропускаємо.'"],
"'Values: ${values.join(' + ')} = $sum.'": [
 "'Werte: ${values.join(' + ')} = $sum.'",
 "'Valeurs : ${values.join(' + ')} = $sum.'",
 "'Valores: ${values.join(' + ')} = $sum.'",
 "'Значення: ${values.join(' + ')} = $sum.'"],
# store.dart, reminders.dart
"'The journal could not be saved'": [
 "'Das Tagebuch konnte nicht gespeichert werden'",
 "'Le journal n’a pas pu être enregistré'",
 "'No se ha podido guardar el diario'",
 "'Не вдалося зберегти щоденник'"],
"'New and full moon'": ["'Neumond und Vollmond'", "'Nouvelle et pleine lune'", "'Luna nueva y llena'", "'Молодик і повня'"],
"'Reflection reminder'": ["'Erinnerung zum Innehalten'", "'Rappel de réflexion'", "'Recordatorio para reflexionar'", "'Нагадування про роздуми'"],
}

root = sys.argv[1]
files = ["lib/engine/numerology.dart", "lib/data/store.dart", "lib/reminders.dart"]
used, left = set(), []
for f in files:
    lines = open(f"{root}/{f}", encoding="utf-8").read().split("\n")
    for i, line in enumerate(lines):
        m = re.search(r"en: ('.*')", line)
        if not m or "de: " in line or (i + 1 < len(lines) and "de: " in lines[i + 1]):
            continue
        # Longest known literal right after `en: ` (a line may hold more quotes after it).
        hits = [k for k in T if f"en: {k}" in line]
        if not hits:
            left.append((f, i + 1, m.group(1))); continue
        lit = max(hits, key=len)
        de, fr, es, uk = T[lit]
        lines[i] = line.replace(f"en: {lit}", f"en: {lit}, de: {de}, fr: {fr}, es: {es}, uk: {uk}", 1)
        used.add(lit)
    open(f"{root}/{f}", "w", encoding="utf-8").write("\n".join(lines))
for x in left: print("untranslated", *x)
print("unused", [k for k in T if k not in used])
