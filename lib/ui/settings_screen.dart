import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/content.dart';
import '../data/store.dart' show DeleteAllResult;
import '../engine/lang.dart';
import '../engine/numerology.dart';
import '../home_widget_sync.dart' show clearHomeWidget;
import '../reminders.dart';
import 'astro_screens.dart' show dailyReminderEvents;
import 'pro_sheet.dart';
import 'widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _deleteAll(BuildContext context) async {
    final l = context.l;
    final nav = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final store = context.store;
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(l.deleteAllTitle),
        content: Text(l.deleteAllBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: Text(l.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(c, true),
            child: Text(l.delete),
          ),
        ],
      ),
    );
    if (ok == true) {
      // cancelAll (daily and moon) runs inside, right after the reminder settings are gone
      final r = await store.deleteAllData(cancelReminders: Reminders.cancelAll);
      if (r != DeleteAllResult.done) {
        messenger.showSnackBar(SnackBar(content: Text(l.deleteAllFailed)));
      } else if (context.mounted) {
        nav.popUntil((route) => route.isFirst);
      }
      // After a started reset the widgets are emptied even on failure (needs no screen); a refused
      // flag means nothing was removed, so they stay. Failure keeps Settings open for a retry.
      if (r != DeleteAllResult.notStarted) await clearHomeWidget(store);
    }
  }

  Future<void> _toggleReminder(BuildContext context, bool on) async {
    final l = context.l;
    final store = context.store;
    final messenger = ScaffoldMessenger.of(context);
    if (!on) {
      await Reminders.disable();
      store.reminderMinutes = null;
      return;
    }
    final t = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 20, minute: 0),
    );
    if (t == null) return;
    if (!context.mounted) return;
    final ok = await Reminders.enable(
      dailyReminderEvents(context, t.hour * 60 + t.minute),
    );
    if (ok) {
      store.reminderMinutes = t.hour * 60 + t.minute;
    } else {
      messenger.showSnackBar(SnackBar(content: Text(l.reminderDenied)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final s = context.store;
    return Scaffold(
      appBar: AppBar(title: Text(l.settings)),
      body: ListView(
        children: [
          ListTile(
            title: Text(l.language),
            trailing: DropdownButton<String>(
              value: appLangs.contains(s.language) ? s.language : 'system',
              underline: const SizedBox(),
              items: [
                DropdownMenuItem(value: 'system', child: Text(l.themeSystem)),
                // Language names stay in their own language.
                for (final c in appLangs)
                  DropdownMenuItem(value: c, child: Text(langNames[c]!)),
              ],
              onChanged: (v) => s.language = v!,
            ),
          ),
          ListTile(title: Text(l.theme)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SegmentedButton<String>(
              segments: [
                ButtonSegment(value: 'system', label: Text(l.themeSystem)),
                ButtonSegment(value: 'light', label: Text(l.themeLight)),
                ButtonSegment(value: 'dark', label: Text(l.themeDark)),
              ],
              selected: {s.themeMode},
              onSelectionChanged: (v) => s.themeMode = v.first,
            ),
          ),
          SwitchListTile(
            title: Text(l.tarotWelcomeSetting),
            value: s.tarotWelcome,
            onChanged: (v) => s.tarotWelcome = v,
          ),
          SwitchListTile(
            title: Text(l.allowReversed),
            subtitle: Text(l.allowReversedRule),
            value: s.allowReversed,
            onChanged: (v) => s.allowReversed = v,
          ),
          if (Reminders.supported)
            SwitchListTile(
              title: Text(l.reminder),
              subtitle: Text(
                s.reminderMinutes == null
                    ? l.reminderOff
                    : l.reminderAt(
                        TimeOfDay(
                          hour: s.reminderMinutes! ~/ 60,
                          minute: s.reminderMinutes! % 60,
                        ).format(context),
                      ),
              ),
              value: s.reminderMinutes != null,
              onChanged: (on) => _toggleReminder(context, on),
            ),
          if (s.birthDate != null || s.fullName != null)
            ListTile(
              title: Text(l.profile),
              subtitle: Text(
                [
                  s.birthDate?.display,
                  s.fullName,
                ].whereType<String>().join(' · '),
              ),
              trailing: TextButton(
                onPressed: () => s.saveProfile(null, null),
                child: Text(l.delete),
              ),
            ),
          const Divider(),
          ListTile(title: Text(l.privacy), subtitle: Text(l.privacyBody)),
          ListTile(
            title: Text(l.privacyPolicy),
            trailing: const Icon(Icons.open_in_new),
            // Both stores require the policy to be reachable from inside the app.
            onTap: () => launchUrl(
              Uri.parse('https://digi-witch.com/prywatnosc/'),
              mode: LaunchMode.externalApplication,
            ),
          ),
          ListTile(
            title: Text(l.deleteAllTitle),
            leading: const Icon(Icons.delete_forever_outlined),
            onTap: () => _deleteAll(context),
          ),
          const Divider(),
          ListTile(
            title: Text(l.licenses),
            trailing: const Icon(Icons.chevron_right),
            onTap: () =>
                showLicensePage(context: context, applicationName: l.appTitle),
          ),
          ListTile(
            title: Text(l.sourcesAndRights),
            subtitle: Text(l.sourcesBody),
          ),
          ListTile(
            leading: const Icon(Icons.workspace_premium_outlined),
            title: Text(l.purchases),
            subtitle: Text(s.isPro ? l.proActive : l.proShort),
            onTap: () => showProSheet(context),
          ),
          if (context.monetization case final m?)
            ListenableBuilder(
              listenable: m,
              builder: (_, _) => m.privacyOptionsRequired && !s.isPro
                  ? ListTile(
                      leading: const Icon(Icons.privacy_tip_outlined),
                      title: Text(l.adPrivacyOptions),
                      onTap: m.showPrivacyOptions,
                    )
                  : const SizedBox.shrink(),
            ),
          ListTile(title: Text(l.help), subtitle: Text(l.helpBody)),
          ListTile(
            title: Text(l.versions),
            subtitle: Text(
              '${l.algorithm}: $algorithmVersion · ${l.contentVer}: $contentVersion',
            ),
          ),
          ListTile(subtitle: Text(l.disclaimer)),
        ],
      ),
    );
  }
}
