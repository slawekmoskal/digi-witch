import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'package:home_widget/home_widget.dart';

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

/// Sends the day texts (and the turned card's picture) to the home-screen widgets.
/// Called at start and whenever stored data changes; never blocks or breaks the app.
Future<void> syncHomeWidget(BuildContext context) async {
  if (!monetizationSupported) return; // Android/iOS only
  final data = widgetPayload(context, DateTime.now());
  try {
    await HomeWidget.setAppGroupId(_appGroup);
    for (final e in data.entries) {
      await HomeWidget.saveWidgetData<String>(e.key, e.value);
    }
    final id = data['cardId']!;
    if (id.isNotEmpty && id != _sentImage) {
      // shortcut: the picture travels as base64 text (~140 KB) next to the other values;
      // switch to a file in the shared container if widgets ever need more images.
      final bytes = await rootBundle.load('assets/cards/$id.webp');
      await HomeWidget.saveWidgetData<String>(
        'cardImage',
        base64Encode(bytes.buffer.asUint8List()),
      );
      _sentImage = id;
    }
    for (final w in _widgets) {
      await HomeWidget.updateWidget(androidName: '${w}Provider', iOSName: w);
    }
  } catch (_) {
    // No widget installed / platform refused: nothing to do.
  }
}

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
