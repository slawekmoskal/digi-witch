import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'ui/widgets.dart' show nativeBarInset, nativeTabs;

const _channel = MethodChannel('digiwitch/tabs');

/// Asks iOS whether it shows the tabs itself (iPhone Duo's vertical bar) and, if so,
/// listens for taps on them. Everywhere else [nativeTabs] stays false.
Future<void> attachNativeTabs({
  required ValueChanged<int> onSelect,
  required VoidCallback onBack,
}) async {
  if (kIsWeb || defaultTargetPlatform != TargetPlatform.iOS) return;
  _channel.setMethodCallHandler((call) async {
    if (call.method == 'select') onSelect(call.arguments as int);
    if (call.method == 'back') onBack();
    if (call.method == 'inset') {
      nativeBarInset.value = (call.arguments as num).toDouble();
    }
  });
  try {
    nativeTabs.value = await _channel.invokeMethod<bool>('attach') ?? false;
  } on MissingPluginException {
    // Plain Flutter view (no vertical bar on this device): the app draws its own menu.
  }
}

/// Keeps the system tabs in step with the app: titles, selection, back button.
void updateNativeTabs({
  required int index,
  required List<String> titles,
  required bool canGoBack,
  required String back,
}) {
  if (!nativeTabs.value) return;
  _channel.invokeMethod('update', {
    'index': index,
    'titles': titles,
    'canGoBack': canGoBack,
    'back': back,
  });
}

/// The first-run screen has no tabs to switch to.
void hideNativeTabs() {
  if (nativeTabs.value) _channel.invokeMethod('hide');
}
