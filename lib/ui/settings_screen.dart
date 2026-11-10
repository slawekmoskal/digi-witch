import 'package:flutter/material.dart';

import '../data/content.dart';
import '../engine/numerology.dart';
import '../reminders.dart';
import 'pro_sheet.dart';
import 'widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _deleteAll(BuildContext context) async {
    final l = context.l;
    final nav = Navigator.of(context);
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
      await Reminders.disable();
      await store.deleteAllData();
      nav.popUntil((r) => r.isFirst);
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
    final ok = await Reminders.enable(
      t.hour,
      t.minute,
      title: l.reminderTitle,
      body: l.reminderBody,
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
            title: Text(l.deleteAllTitle),
            leading: const Icon(Icons.delete_forever_outlined),
            onTap: () => _deleteAll(context),
          ),
          const Divider(),
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
