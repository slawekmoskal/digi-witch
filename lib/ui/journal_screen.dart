import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../data/store.dart';
import 'widgets.dart';

class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key});

  Future<void> _export(BuildContext context) async {
    final json = context.store.exportJournal();
    final dir = await getTemporaryDirectory();
    final f = File('${dir.path}/dziennik.json');
    await f.writeAsString(json);
    await SharePlus.instance.share(
      ShareParams(files: [XFile(f.path, mimeType: 'application/json')]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final entries = context.store.journal;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.tabJournal),
        actions: [
          if (entries.isNotEmpty)
            IconButton(
              tooltip: l.exportJournal,
              icon: const Icon(Icons.ios_share),
              onPressed: () => _export(context),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: Text(l.newEntry),
        onPressed: () =>
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const EntryEditor())),
      ),
      body: entries.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(l.journalEmpty, textAlign: TextAlign.center),
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
              children: [
                Text(
                  l.journalPrivacy,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                for (final e in entries)
                  Card(
                    child: ListTile(
                      title: Text(
                        e.text,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        [
                          MaterialLocalizations.of(context)
                              .formatMediumDate(e.createdAt),
                          if (e.ref?['label'] != null) e.ref!['label'],
                        ].join(' · '),
                      ),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => EntryEditor(existing: e),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}

class EntryEditor extends StatefulWidget {
  final JournalEntry? existing;
  final String? promptText;
  final Map<String, dynamic>? ref;
  const EntryEditor({super.key, this.existing, this.promptText, this.ref});
  @override
  State<EntryEditor> createState() => _EntryEditorState();
}

class _EntryEditorState extends State<EntryEditor> {
  late final _text = TextEditingController(text: widget.existing?.text ?? '');
  late String? _prompt = widget.existing?.promptText ?? widget.promptText;
  String _category = 'ogolne';

  void _randomPrompt() {
    final list = context.content.prompts
        .where((p) => p.category == _category)
        .toList();
    if (list.isNotEmpty) {
      setState(() => _prompt = list[Random().nextInt(list.length)].text);
    }
  }

  Future<void> _save() async {
    final s = context.store;
    final t = _text.text.trim();
    if (t.isEmpty) return;
    final nav = Navigator.of(context);
    widget.existing == null
        ? await s.addEntry(t, promptText: _prompt, ref: widget.ref)
        : await s.updateEntry(widget.existing!.id, t);
    nav.pop();
  }

  Future<void> _delete() async {
    final l = context.l;
    final nav = Navigator.of(context);
    final store = context.store;
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        content: Text(l.deleteEntryConfirm),
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
      await store.deleteEntry(widget.existing!.id);
      nav.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final ref = widget.existing?.ref ?? widget.ref;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existing == null ? l.newEntry : l.editEntry),
        actions: [
          if (widget.existing != null)
            IconButton(
              tooltip: l.delete,
              icon: const Icon(Icons.delete_outline),
              onPressed: _delete,
            ),
          TextButton(onPressed: _save, child: Text(l.save)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (ref != null)
            LabeledBlock(l.linkedResult, Text('${ref['label']}')),
          if (widget.existing == null && widget.promptText == null) ...[
            SectionTitle(l.promptsTitle),
            Wrap(
              spacing: 8,
              children: [
                for (final c in const ['ogolne', 'rodzina', 'tarot', 'liczby'])
                  ChoiceChip(
                    label: Text(l.promptCategory(c)),
                    selected: _category == c,
                    onSelected: (_) => setState(() => _category = c),
                  ),
              ],
            ),
            TextButton.icon(
              icon: const Icon(Icons.casino_outlined),
              label: Text(l.randomPrompt),
              onPressed: _randomPrompt,
            ),
          ],
          if (_prompt != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                _prompt!,
                style: Theme.of(context).textTheme.titleMedium
                    ?.copyWith(fontStyle: FontStyle.italic),
              ),
            ),
          if (_category == 'rodzina' && widget.existing == null)
            Text(l.familyNote, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 8),
          TextField(
            controller: _text,
            minLines: 8,
            maxLines: null,
            autofocus: widget.existing == null,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: l.entryHint,
            ),
          ),
        ],
      ),
    );
  }
}
