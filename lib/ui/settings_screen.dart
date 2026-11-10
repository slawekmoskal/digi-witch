import 'package:flutter/material.dart';

import '../data/content.dart';
import '../engine/numerology.dart';
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
          TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l.cancel)),
          TextButton(onPressed: () => Navigator.pop(c, true), child: Text(l.delete)),
        ],
      ),
    );
    if (ok == true) {
      await store.deleteAllData();
      nav.popUntil((r) => r.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final s = context.store;
    return Scaffold(
      appBar: AppBar(title: Text(l.settings)),
      body: ListView(children: [
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
        if (s.birthDate != null || s.fullName != null)
          ListTile(
            title: Text(l.profile),
            subtitle: Text([s.birthDate?.display, s.fullName].whereType<String>().join(' · ')),
            trailing: TextButton(onPressed: () => s.saveProfile(null, null), child: Text(l.delete)),
          ),
        const Divider(),
        ListTile(title: Text(l.privacy), subtitle: Text(l.privacyBody)),
        ListTile(
          title: Text(l.deleteAllTitle),
          leading: const Icon(Icons.delete_forever_outlined),
          onTap: () => _deleteAll(context),
        ),
        const Divider(),
        ListTile(title: Text(l.sourcesAndRights), subtitle: Text(l.sourcesBody)),
        ListTile(title: Text(l.purchases), subtitle: Text(l.purchasesBody)),
        ListTile(title: Text(l.help), subtitle: Text(l.helpBody)),
        ListTile(
          title: Text(l.versions),
          subtitle: Text('${l.algorithm}: $algorithmVersion · ${l.contentVer}: $contentVersion'),
        ),
        ListTile(subtitle: Text(l.disclaimer)),
      ]),
    );
  }
}
