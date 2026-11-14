import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'package:home_widget/home_widget.dart';

import 'data/store.dart' show AppStore;
import 'monetization/monetization.dart' show monetizationSupported;
import 'ui/astro_screens.dart' show widgetPayload;

/// App Group shared with the iOS widget extension. The local demo build (different bundle id)
/// overrides it with --dart-define=APP_GROUP=…
const _appGroup = String.fromEnvironment(
  'APP_GROUP',
  defaultValue: 'group.com.digiwitch.app',
);

// Widget kinds: iOS `kind` strings and Android provider class names.
const _widgets = [
  'HoroscopeWidget',
  'CardWidget',
  'MoonWidget',
  'DayLargeWidget',
  'ThoughtWidget',
];

String? _sentImage; // card id whose picture the widget already has

// A reset bumps the epoch; a push that started earlier sees it and stops writing.
int _epoch = 0;
Future<void>? _inFlight; // pushes run one at a time

/// Each testWidgets runs in its own fake zone; a future left from an earlier test delivers its
/// callbacks to that dead zone and hangs everything chained after it. So the chain is dropped,
/// and the next call starts a new one in its own zone. Synchronous on purpose (awaiting in a
/// tearDown hangs): a test must finish its pushes inside its own body; this only detaches state.
@visibleForTesting
void resetHomeWidgetSyncForTest() {
  _epoch++; // never back to 0: an old push remembering an earlier epoch must stay invalid
  _inFlight = null;
  _sentImage = null;
}

/// Sends the day texts (and the turned card's picture) to the home-screen widgets.
/// Called at start and whenever stored data changes; never blocks or breaks the app.
Future<void> syncHomeWidget(BuildContext context) {
  if (!monetizationSupported) return Future.value(); // Android/iOS only
  final data = widgetPayload(context, DateTime.now());
  final epoch = _epoch;
  return _inFlight = (_inFlight ?? Future.value()).then(
    (_) => _push(data, epoch),
  );
}

Future<void> _push(Map<String, String> data, int epoch) async {
  try {
    await HomeWidget.setAppGroupId(_appGroup);
    for (final e in data.entries) {
      if (epoch != _epoch) return;
      await HomeWidget.saveWidgetData<String>(e.key, e.value);
    }
    final id = data['cardId']!;
    if (id.isNotEmpty && id != _sentImage) {
      // shortcut: the picture travels as base64 text (~140 KB) next to the other values;
      // switch to a file in the shared container if widgets ever need more images.
      final bytes = await rootBundle.load('assets/cards/$id.webp');
      if (epoch != _epoch) return;
      await HomeWidget.saveWidgetData<String>(
        'cardImage',
        base64Encode(bytes.buffer.asUint8List()),
      );
      _sentImage = id;
    }
    if (epoch != _epoch) return;
    await _refresh();
  } catch (_) {
    // No widget installed / platform refused: nothing to do.
  }
}

Future<bool> _refresh() async {
  var ok = true;
  for (final w in _widgets) {
    ok =
        await HomeWidget.updateWidget(
              androidName: '${w}Provider',
              iOSName: w,
            ) !=
            false &&
        ok;
  }
  return ok;
}

// Every key widgetPayload() writes, plus the picture; a test keeps this list in step.
const widgetKeys = [
  'days', 'cardDate', 'cardId', 'cardName', 'cardAdvice', 'cardReversed',
  'cardTitle', 'cardWaiting', 'needBirth', 'stale', 'loveLabel', 'workLabel',
  'energyLabel', 'cardImage', //
];

/// Empties the shared widget store and refreshes the widgets. Needs no screen, so it runs
/// whatever the user has navigated to. Waits for a push in flight (and later pushes wait for
/// this), so old data is never written after the wipe. Leaves the store's pending flag set
/// when the plugin throws or answers false: [retryPendingHomeWidgetClear] tries again at start.
Future<void> clearHomeWidget(AppStore store) {
  if (!monetizationSupported) return Future.value();
  _epoch++;
  return _inFlight = (_inFlight ?? Future.value()).then((_) async {
    _sentImage = null;
    try {
      var ok = await HomeWidget.setAppGroupId(_appGroup) != false;
      for (final k in widgetKeys) {
        ok = await HomeWidget.saveWidgetData<String>(k, null) != false && ok;
      }
      if (await _refresh() && ok) await store.setWidgetClearDone();
    } catch (_) {
      // Plugin refused: the flag stays, the next start retries.
    }
  });
}

/// At app start, also from the onboarding screen: finishes a clearing the last run left undone.
Future<void> retryPendingHomeWidgetClear(AppStore store) =>
    store.widgetClearPending ? clearHomeWidget(store) : Future.value();

/// Calls [open] with the target ("horoscope", "card", "moon") when a widget is tapped,
/// including the tap that launched the app.
StreamSubscription<Uri?>? listenWidgetTaps(void Function(String target) open) {
  if (!monetizationSupported) return null;
  void handle(Uri? u) {
    if (u != null) open(u.host);
  }

  HomeWidget.setAppGroupId(_appGroup).catchError((_) => null);
  HomeWidget.initiallyLaunchedFromHomeWidget().then(handle).catchError((_) {});
  return HomeWidget.widgetClicked.listen(handle, onError: (_) {});
}
