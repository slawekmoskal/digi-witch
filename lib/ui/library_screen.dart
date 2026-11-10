import 'package:flutter/material.dart';

import '../data/content.dart';
import 'tarot_screen.dart';
import 'widgets.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});
  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  String _q = '';

  bool _hit(String s) => s.toLowerCase().contains(_q);

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final c = context.content;
    final marks = context.store.bookmarks;
    final cards = c.cards.values.where((k) => _q.isEmpty || _hit(k.name) || k.keywords.any(_hit)).toList();
    final arche = c.archetypes.where((a) => _q.isEmpty || _hit(a.name) || _hit(a.summary)).toList();
    final terms = c.glossary.where((t) => _q.isEmpty || _hit(t.term) || _hit(t.definition)).toList();
    final arts = c.articles.where((a) => _q.isEmpty || _hit(a.title) || _hit(a.body)).toList();
    void open(Widget w) => Navigator.of(context).push(MaterialPageRoute(builder: (_) => w));

    return Scaffold(
      appBar: AppBar(title: Text(l.tabLibrary)),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        TextField(
          decoration: InputDecoration(prefixIcon: const Icon(Icons.search), hintText: l.search, border: const OutlineInputBorder()),
          onChanged: (v) => setState(() => _q = v.trim().toLowerCase()),
        ),
        if (_q.isEmpty && marks.isNotEmpty) ...[
          SectionTitle(l.bookmarks),
          for (final id in marks)
            if (c.cards[id] != null) ListTile(title: Text(c.cards[id]!.name), leading: const Icon(Icons.bookmark), onTap: () => open(CardDetail(c.cards[id]!))),
        ],
        if (arts.isNotEmpty) SectionTitle(l.articles),
        for (final a in arts) ListTile(title: Text(a.title), trailing: const Icon(Icons.chevron_right), onTap: () => open(ArticleView(a))),
        if (cards.isNotEmpty) SectionTitle(l.cardsCount(cards.length)),
        for (final k in cards) ListTile(title: Text(k.name), subtitle: Text(k.group), onTap: () => open(CardDetail(k))),
        if (arche.isNotEmpty) ...[SectionTitle(l.archetypes), Text(l.archetypesNote, style: Theme.of(context).textTheme.bodySmall)],
        for (final a in arche) ListTile(title: Text(a.name), subtitle: Text(a.summary, maxLines: 2), onTap: () => open(ArchetypeView(a))),
        if (terms.isNotEmpty) SectionTitle(l.glossary),
        for (final t in terms) ExpansionTile(title: Text(t.term), childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12), children: [Text(t.definition)]),
      ]),
    );
  }
}

class ArticleView extends StatelessWidget {
  final Article a;
  const ArticleView(this.a, {super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(a.title)),
        body: ListView(padding: const EdgeInsets.all(16), children: [
          for (final p in a.body.split(RegExp(r'\n\s*\n')))
            Padding(padding: const EdgeInsets.only(bottom: 12), child: SelectableText(p.trim())),
        ]),
      );
}

class ArchetypeView extends StatelessWidget {
  final Archetype a;
  const ArchetypeView(this.a, {super.key});
  @override
  Widget build(BuildContext context) {
    final l = context.l;
    return Scaffold(
      appBar: AppBar(title: Text(a.name)),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Text(a.summary),
        LabeledBlock(l.archetypeGifts, Text(a.gifts)),
        LabeledBlock(l.archetypeShadow, Text(a.shadow)),
        LabeledBlock(l.reflectionQuestions, Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          for (final q in a.reflection) Text('• $q'),
        ])),
        SaveReflectionButton(prompt: a.reflection.first, ref: {'type': 'archetype', 'label': a.name, 'id': a.id}),
        LabeledBlock(l.aboutModel, Text(l.archetypesNote, style: Theme.of(context).textTheme.bodySmall)),
      ]),
    );
  }
}
