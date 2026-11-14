import SwiftUI
import WidgetKit

// Widgets: horoscope, card of the day, Moon (one theme each), plus two large ones that
// bring them together: "Your day" (dated) and "Good thought" (no date, no birth date needed).
// The app writes a week of day texts ("days", JSON) plus today's card into the shared
// App Group (home_widget plugin); each timeline entry picks its own date, so the widgets
// stay right for days without opening the app. Nothing is fetched from the network.

private struct Day: Decodable {
  let date, label, sign, text, caution, number, color, phaseName, moonIn, next, mercury: String
  let phase: Int
  /// Day meters 1–5; missing or 0 when the app sent no reading for the day.
  let love, work, energy: Int?
  /// The day's warm headline from the meters; missing in older data.
  let cheer: String?
  /// What the Moon phase favours; needs no birth date.
  let moonCheer: String?
  /// Kind words for everyone, one per day; needs no birth date.
  let message: String?
  /// The greeting as the app shows it: good news from the reading first, else the message.
  let lead, support: String?
}

struct DayEntry: TimelineEntry {
  let date: Date
  fileprivate let day: Day?
  /// Today's card, only once the user has turned it in the app.
  let cardName, cardAdvice: String
  let cardImage: UIImage?
  let cardTitle, cardWaiting, needBirth, stale: String
  let loveLabel, workLabel, energyLabel: String
}

struct DayProvider: TimelineProvider {
  // Set per build configuration (APP_GROUP_ID), so the demo bundle can use its own group.
  private static let group = Bundle.main.object(forInfoDictionaryKey: "AppGroupId") as? String ?? ""

  private func entry(for date: Date) -> DayEntry {
    let store = UserDefaults(suiteName: Self.group)
    func text(_ key: String, _ fallback: String = "") -> String {
      store?.string(forKey: key) ?? fallback
    }
    let iso = DateFormatter()
    iso.calendar = Calendar(identifier: .gregorian)
    iso.locale = Locale(identifier: "en_US_POSIX")
    iso.dateFormat = "yyyy-MM-dd"
    let today = iso.string(from: date)
    let days =
      (store?.string(forKey: "days")?.data(using: .utf8))
      .flatMap { try? JSONDecoder().decode([Day].self, from: $0) } ?? []
    let turned = text("cardDate") == today && !text("cardName").isEmpty
    var image: UIImage?
    if turned, let data = Data(base64Encoded: text("cardImage")), let full = UIImage(data: data) {
      // Widgets have a tight memory budget: keep a thumbnail, upside down for a reversed card.
      let small = full.preparingThumbnail(of: CGSize(width: 240, height: 417)) ?? full
      image =
        text("cardReversed") == "1"
        ? UIImage(cgImage: small.cgImage!, scale: small.scale, orientation: .down) : small
    }
    return DayEntry(
      date: date,
      day: days.first(where: { $0.date == today }),
      cardName: turned ? text("cardName") : "",
      cardAdvice: turned ? text("cardAdvice") : "",
      cardImage: image,
      cardTitle: text("cardTitle", "Karta dnia"),
      cardWaiting: text("cardWaiting", "Czeka na odsłonięcie"),
      needBirth: text("needBirth", "Podaj datę urodzenia, a zobaczysz swój dzień."),
      stale: text("stale", "Stuknij, aby zobaczyć swój dzień"),
      loveLabel: text("loveLabel", "Miłość"),
      workLabel: text("workLabel", "Praca"),
      energyLabel: text("energyLabel", "Energia"))
  }

  func placeholder(in context: Context) -> DayEntry {
    DayEntry(
      date: Date(),
      day: Day(
        date: "", label: "wtorek, 10 listopada", sign: "Rak",
        text: "Dziś łatwiej usłyszysz, czego naprawdę chcesz. Daj sobie na to chwilę.",
        caution: "Uważaj na pośpiech w rozmowach.", number: "7 · Dzień refleksji",
        color: "Kolor dnia: fioletowy", phaseName: "Pełnia", moonIn: "Księżyc w Raku",
        next: "Nów za 14 dni", mercury: "", phase: 4, love: 4, work: 3, energy: 5,
        cheer: "Dobry dzień dla serca", moonCheer: "Pełnia — czas docenić to, co już masz",
        message: "Dobrze, że jesteś. Ten dzień jest lepszy z Tobą.",
        lead: "Dobry dzień dla serca", support: "Dobrze, że jesteś. Ten dzień jest lepszy z Tobą."),
      cardName: "", cardAdvice: "", cardImage: nil, cardTitle: "Karta dnia",
      cardWaiting: "Czeka na odsłonięcie", needBirth: "", stale: "",
      loveLabel: "Miłość", workLabel: "Praca", energyLabel: "Energia")
  }

  func getSnapshot(in context: Context, completion: @escaping (DayEntry) -> Void) {
    completion(context.isPreview ? placeholder(in: context) : entry(for: Date()))
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<DayEntry>) -> Void) {
    // Now, then each of the next seven midnights.
    let cal = Calendar.current
    let start = cal.startOfDay(for: Date())
    var entries = [entry(for: Date())]
    for i in 1...7 {
      if let d = cal.date(byAdding: .day, value: i, to: start) { entries.append(entry(for: d)) }
    }
    completion(Timeline(entries: entries, policy: .atEnd))
  }
}

// MARK: - Look

private let gold = Color(red: 0.95, green: 0.85, blue: 0.54)
private let parchment = Color(red: 0.95, green: 0.91, blue: 0.82)
private let indigo = LinearGradient(
  colors: [Color(red: 0.35, green: 0.30, blue: 0.54), Color(red: 0.18, green: 0.15, blue: 0.32)],
  startPoint: .topLeading, endPoint: .bottomTrailing)

/// The `homeWidget` query marks the URL as a widget tap for the plugin.
private func link(_ target: String) -> URL? { URL(string: "digiwitch://\(target)?homeWidget") }

private struct Label: View {
  let text: String
  var body: some View {
    Text(text.uppercased()).font(.caption2.weight(.bold)).tracking(0.6).foregroundStyle(gold)
      .lineLimit(1).minimumScaleFactor(0.7)
  }
}

/// Five dots, [value] of them filled.
private struct Dots: View {
  let value: Int
  var size: CGFloat = 7
  var body: some View {
    HStack(spacing: size * 0.45) {
      ForEach(1...5, id: \.self) { i in
        Circle().fill(i <= value ? gold : Color.white.opacity(0.22))
          .frame(width: size, height: size)
      }
    }
  }
}

// MARK: - Horoscope

struct HoroscopeView: View {
  @Environment(\.widgetFamily) private var family
  let entry: DayEntry

  var body: some View {
    let small = family == .systemSmall
    VStack(alignment: .leading, spacing: 4) {
      if let d = entry.day, !d.text.isEmpty {
        let cheer = d.cheer ?? ""
        // Small widget: the headline takes the sign's place to leave room for the meters.
        if !small || cheer.isEmpty {
          Label(text: small ? d.sign : "\(d.sign) · \(d.label)")
        }
        if !cheer.isEmpty {
          Text(cheer).font((small ? Font.footnote : .headline).weight(.semibold))
            .foregroundStyle(.white).lineLimit(2).minimumScaleFactor(0.8)
        }
        // Love, work, energy as in the app's horoscope; older data has no meters.
        let meters = [
          (entry.loveLabel, d.love ?? 0), (entry.workLabel, d.work ?? 0),
          (entry.energyLabel, d.energy ?? 0),
        ]
        if (d.love ?? 0) == 0 {
          Text(d.text).font(small ? .footnote : .subheadline).foregroundStyle(.white)
            .lineLimit(cheer.isEmpty ? (small ? 5 : 3) : 2)
          if !small && cheer.isEmpty {
            Text(d.caution).font(.caption).foregroundStyle(parchment.opacity(0.85)).lineLimit(2)
          }
        } else if small {
          // Small: the three meters are the whole message.
          ForEach(meters, id: \.0) { m in
            HStack(spacing: 4) {
              Text(m.0).font(.footnote).foregroundStyle(.white).lineLimit(1)
                .minimumScaleFactor(0.7)
              Spacer(minLength: 2)
              Dots(value: m.1)
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("\(m.0): \(m.1)/5")
          }
        } else {
          // The headline stands in for the day's line; the full text is in the app.
          if cheer.isEmpty {
            Text(d.text).font(.subheadline).foregroundStyle(.white).lineLimit(2)
          }
          HStack(alignment: .top, spacing: 10) {
            ForEach(meters, id: \.0) { m in
              VStack(alignment: .leading, spacing: 2) {
                Text(m.0).font(.caption2).foregroundStyle(parchment).lineLimit(1)
                  .minimumScaleFactor(0.7)
                Dots(value: m.1)
              }
              .frame(maxWidth: .infinity, alignment: .leading)
              .accessibilityElement(children: .ignore)
              .accessibilityLabel("\(m.0): \(m.1)/5")
            }
          }
          .padding(.top, 2)
        }
        Spacer(minLength: 0)
        HStack {
          Text(small ? d.number : "\(d.number) · \(d.color)")
            .font(.caption2.weight(.semibold)).foregroundStyle(gold).lineLimit(1)
            .minimumScaleFactor(0.7)
          Spacer(minLength: 4)
          Image(systemName: "chevron.right").font(.caption2).foregroundStyle(gold)
        }
      } else if let d = entry.day {
        // No birth date yet: the Moon, and what a date would add.
        Label(text: d.label)
        Text("\(d.phaseName) · \(d.moonIn)").font(.subheadline.weight(.semibold))
          .foregroundStyle(.white).lineLimit(2)
        Text(entry.needBirth).font(.caption).foregroundStyle(parchment).lineLimit(3)
        Spacer(minLength: 0)
      } else {
        Label(text: "Digi Witch")
        Text(entry.stale).font(.subheadline).foregroundStyle(.white)
        Spacer(minLength: 0)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    .containerBackground(for: .widget) { indigo }
    .widgetURL(link("horoscope"))
  }
}

struct HoroscopeWidget: Widget {
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: "HoroscopeWidget", provider: DayProvider()) {
      HoroscopeView(entry: $0)
    }
    .configurationDisplayName("Dziś dla Ciebie")
    .description("Horoskop na dziś: nastrój, miłość, praca, energia i liczba dnia.")
    .supportedFamilies([.systemMedium, .systemSmall])
  }
}

// MARK: - Card of the day

struct CardView: View {
  @Environment(\.widgetFamily) private var family
  let entry: DayEntry

  var body: some View {
    let small = family == .systemSmall
    HStack(alignment: .center, spacing: 12) {
      Group {
        if let image = entry.cardImage {
          Image(uiImage: image).resizable().aspectRatio(contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 5))
        } else {
          // The card's back, like in the app.
          RoundedRectangle(cornerRadius: 6)
            .fill(
              LinearGradient(
                colors: [
                  Color(red: 0.42, green: 0.36, blue: 0.62), Color(red: 0.24, green: 0.20, blue: 0.42),
                ], startPoint: .top, endPoint: .bottom)
            )
            .overlay(RoundedRectangle(cornerRadius: 4).strokeBorder(gold, lineWidth: 1).padding(4))
            .overlay(Image(systemName: "sparkle").font(.title3).foregroundStyle(parchment))
            .aspectRatio(0.58, contentMode: .fit)
        }
      }
      .frame(maxWidth: small ? 52 : 74)
      VStack(alignment: .leading, spacing: 3) {
        Label(text: entry.cardTitle)
        if entry.cardName.isEmpty {
          Text(entry.cardWaiting).font(small ? .subheadline : .headline).foregroundStyle(.white)
            .lineLimit(3)
        } else {
          Text(entry.cardName).font(small ? .subheadline.weight(.semibold) : .headline)
            .foregroundStyle(.white).lineLimit(2).minimumScaleFactor(0.8)
          if !small {
            Text(entry.cardAdvice).font(.caption).foregroundStyle(parchment).lineLimit(4)
          }
        }
      }
      Spacer(minLength: 0)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .containerBackground(for: .widget) { indigo }
    .widgetURL(link("card"))
  }
}

struct CardWidget: Widget {
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: "CardWidget", provider: DayProvider()) { CardView(entry: $0) }
      .configurationDisplayName("Karta dnia")
      .description("Zakryta, dopóki jej nie odsłonisz. Potem karta i jej rada.")
      .supportedFamilies([.systemSmall, .systemMedium])
  }
}

// MARK: - Moon

private let moonSymbols = [
  "moonphase.new.moon", "moonphase.waxing.crescent", "moonphase.first.quarter",
  "moonphase.waxing.gibbous", "moonphase.full.moon", "moonphase.waning.gibbous",
  "moonphase.last.quarter", "moonphase.waning.crescent",
]

struct MoonView: View {
  @Environment(\.widgetFamily) private var family
  let entry: DayEntry

  var body: some View {
    let d = entry.day
    let symbol = moonSymbols[min(max(d?.phase ?? 0, 0), 7)]
    Group {
      switch family {
      case .accessoryCircular:
        ZStack {
          AccessoryWidgetBackground()
          Image(systemName: symbol).font(.title)
        }
        .containerBackground(.clear, for: .widget)
      case .accessoryRectangular:
        HStack(spacing: 8) {
          Image(systemName: symbol).font(.title2)
          VStack(alignment: .leading, spacing: 1) {
            Text(d?.phaseName ?? "Digi Witch").font(.headline).lineLimit(1)
            Text(d?.moonIn ?? entry.stale).font(.caption).lineLimit(1)
            if let next = d?.next, !next.isEmpty { Text(next).font(.caption).lineLimit(1) }
          }
          Spacer(minLength: 0)
        }
        .containerBackground(.clear, for: .widget)
      default:
        VStack(alignment: .leading, spacing: 2) {
          Image(systemName: symbol).font(.system(size: 34)).foregroundStyle(gold)
          Spacer(minLength: 2)
          Text(d?.phaseName ?? "Digi Witch").font(.headline).foregroundStyle(.white).lineLimit(1)
            .minimumScaleFactor(0.7)
          Text(d?.moonIn ?? entry.stale).font(.caption).foregroundStyle(parchment).lineLimit(2)
          if let next = d?.next, !next.isEmpty {
            Text(next).font(.caption2.weight(.semibold)).foregroundStyle(gold).lineLimit(1)
              .minimumScaleFactor(0.7)
          }
          if let mercury = d?.mercury, !mercury.isEmpty {
            Text(mercury).font(.caption2).foregroundStyle(parchment.opacity(0.75)).lineLimit(1)
              .minimumScaleFactor(0.7)
          }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .containerBackground(for: .widget) { indigo }
      }
    }
    .widgetURL(link("moon"))
  }
}

struct MoonWidget: Widget {
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: "MoonWidget", provider: DayProvider()) { MoonView(entry: $0) }
      .configurationDisplayName("Księżyc")
      .description("Faza, znak i najbliższa pełnia lub nów.")
      .supportedFamilies([.systemSmall, .accessoryCircular, .accessoryRectangular])
  }
}

// MARK: - Large: your day

/// The card of the day, or its back while it waits to be turned in the app.
private struct CardThumb: View {
  let image: UIImage?
  var body: some View {
    if let image {
      Image(uiImage: image).resizable().aspectRatio(contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 5))
    } else {
      RoundedRectangle(cornerRadius: 6)
        .fill(
          LinearGradient(
            colors: [
              Color(red: 0.42, green: 0.36, blue: 0.62), Color(red: 0.24, green: 0.20, blue: 0.42),
            ], startPoint: .top, endPoint: .bottom)
        )
        .overlay(RoundedRectangle(cornerRadius: 4).strokeBorder(gold, lineWidth: 1).padding(4))
        .overlay(Image(systemName: "sparkle").font(.title3).foregroundStyle(parchment))
        .aspectRatio(0.58, contentMode: .fit)
    }
  }
}

private struct MoonRow: View {
  let day: Day
  var body: some View {
    HStack(spacing: 8) {
      Image(systemName: moonSymbols[min(max(day.phase, 0), 7)]).font(.title2).foregroundStyle(gold)
      VStack(alignment: .leading, spacing: 1) {
        Text(day.phaseName).font(.footnote.weight(.semibold)).foregroundStyle(.white)
          .lineLimit(2).minimumScaleFactor(0.8)
        Text(day.next.isEmpty ? day.moonIn : day.next).font(.caption).foregroundStyle(parchment)
          .lineLimit(1).minimumScaleFactor(0.7)
      }
    }
  }
}

struct DayLargeView: View {
  let entry: DayEntry

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      if let d = entry.day {
        let personal = !d.text.isEmpty
        Label(text: personal ? "\(d.sign) · \(d.label)" : d.label)
        // As in the app: the message of the day, then the day's own strong point.
        let cheer = d.support ?? (personal ? (d.cheer ?? "") : (d.moonCheer ?? d.phaseName))
        Text(d.lead ?? d.message ?? cheer)
          .font(.system(.title3, design: .serif).weight(.semibold)).foregroundStyle(.white)
          .lineLimit(3).minimumScaleFactor(0.8)
        if d.lead != nil || d.message != nil, !cheer.isEmpty {
          Text(cheer).font(.subheadline.weight(.semibold)).foregroundStyle(gold)
            .lineLimit(2).minimumScaleFactor(0.8)
        }
        if personal {
          if (d.love ?? 0) > 0 {
            // One row per area: name on the left, large dots on the right.
            VStack(spacing: 7) {
              ForEach(
                [
                  (entry.loveLabel, d.love ?? 0), (entry.workLabel, d.work ?? 0),
                  (entry.energyLabel, d.energy ?? 0),
                ], id: \.0
              ) { m in
                HStack {
                  Text(m.0).font(.subheadline.weight(.medium)).foregroundStyle(.white)
                    .lineLimit(1).minimumScaleFactor(0.7)
                  Spacer(minLength: 8)
                  Dots(value: m.1, size: 12)
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("\(m.0): \(m.1)/5")
              }
            }
            .padding(.top, 2)
          }
          // The day's line fills what is left; it is the first to give way.
          Text(d.text).font(.footnote).foregroundStyle(parchment).lineLimit(3)
            .layoutPriority(-1)
        } else {
          Text(entry.needBirth).font(.subheadline).foregroundStyle(parchment).lineLimit(3)
        }
        Spacer(minLength: 0)
        Divider().overlay(gold.opacity(0.4))
        HStack(alignment: .center, spacing: 12) {
          CardThumb(image: entry.cardImage).frame(maxWidth: 40)
          VStack(alignment: .leading, spacing: 1) {
            Text(entry.cardTitle.uppercased()).font(.caption2.weight(.bold)).foregroundStyle(gold)
              .lineLimit(1)
            Text(entry.cardName.isEmpty ? entry.cardWaiting : entry.cardName)
              .font(.subheadline.weight(.semibold)).foregroundStyle(.white).lineLimit(2)
              .minimumScaleFactor(0.8)
          }
          .frame(maxWidth: .infinity, alignment: .leading)
          MoonRow(day: d).frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxHeight: 62)
        if personal {
          Text("\(d.number) · \(d.color)").font(.caption.weight(.semibold)).foregroundStyle(gold)
            .lineLimit(1).minimumScaleFactor(0.7)
        }
      } else {
        Label(text: "Digi Witch")
        Text(entry.stale).font(.title3).foregroundStyle(.white)
        Spacer(minLength: 0)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    .containerBackground(for: .widget) { indigo }
    .widgetURL(link("horoscope"))
  }
}

struct DayLargeWidget: Widget {
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: "DayLargeWidget", provider: DayProvider()) {
      DayLargeView(entry: $0)
    }
    .configurationDisplayName("Twój dzień")
    .description("Cały dzień na jednym ekranie: hasło dnia, horoskop, karta i Księżyc.")
    .supportedFamilies([.systemLarge])
  }
}

// MARK: - Large: good thought (no date)

struct ThoughtView: View {
  let entry: DayEntry

  var body: some View {
    let d = entry.day
    // The message of the day leads; under the card the day's strong point (with a birth
    // date) or what the Moon favours. Never a date.
    let cheer = d?.support ?? (d?.cheer).flatMap { $0.isEmpty ? nil : $0 } ?? d?.moonCheer
    let headline = d?.lead ?? d?.message ?? cheer ?? entry.stale
    VStack(spacing: 8) {
      Image(systemName: "sparkle").font(.subheadline).foregroundStyle(gold)
      Text(headline).font(.system(.title2, design: .serif).weight(.semibold))
        .foregroundStyle(.white).multilineTextAlignment(.center).lineLimit(4)
        .minimumScaleFactor(0.7)
      // As in the app's card: the day's own strong point right under the message.
      if let cheer, cheer != headline {
        Rectangle().fill(gold.opacity(0.4)).frame(width: 44, height: 1).padding(.vertical, 2)
        Text(cheer).font(.subheadline.weight(.semibold)).foregroundStyle(gold)
          .multilineTextAlignment(.center).lineLimit(2).minimumScaleFactor(0.8)
      }
      Spacer(minLength: 4)
      HStack(alignment: .center, spacing: 14) {
        CardThumb(image: entry.cardImage).frame(maxWidth: 62)
        VStack(alignment: .leading, spacing: 3) {
          Text(entry.cardName.isEmpty ? entry.cardWaiting : entry.cardName)
            .font(.headline).foregroundStyle(.white).lineLimit(2).minimumScaleFactor(0.8)
          if !entry.cardAdvice.isEmpty {
            Text(entry.cardAdvice).font(.caption).foregroundStyle(parchment).lineLimit(3)
          }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
      }
      .frame(maxHeight: 106)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .containerBackground(for: .widget) { indigo }
    .widgetURL(link("card"))
  }
}

struct ThoughtWidget: Widget {
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: "ThoughtWidget", provider: DayProvider()) { ThoughtView(entry: $0) }
      .configurationDisplayName("Dobra myśl")
      .description("Dobre słowo na dziś, karta dnia i Księżyc — bez daty.")
      .supportedFamilies([.systemLarge])
  }
}

@main
struct DigiWitchWidgets: WidgetBundle {
  var body: some Widget {
    HoroscopeWidget()
    CardWidget()
    MoonWidget()
    DayLargeWidget()
    ThoughtWidget()
  }
}
