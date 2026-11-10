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
    final cards = c.cards.values
        .where((k) => _q.isEmpty || _hit(k.name) || k.keywords.any(_hit))
        .toList();
    final arche = c.archetypes
        .where((a) => _q.isEmpty || _hit(a.name) || _hit(a.summary))
        .toList();
    final terms = c.glossary
        .where((t) => _q.isEmpty || _hit(t.term) || _hit(t.definition))
        .toList();
    final dreams = c.dreams
        .where((d) => _q.isNotEmpty && _hit(d.symbol))
        .toList();
    final arts = c.articles
        .where((a) => _q.isEmpty || _hit(a.title) || _hit(a.body))
        .toList();
    void open(Widget w) =>
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => w));

    return Scaffold(
      appBar: AppBar(title: Text(l.tabLibrary)),
      body: ListView(
        padding: pagePadding(context),
        children: [
          TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: l.search,
            ),
            onChanged: (v) => setState(() => _q = v.trim().toLowerCase()),
          ),
          if (_q.isEmpty) ...[
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: Icon(
                  Icons.nights_stay_outlined,
                  color: Theme.of(context).colorScheme.tertiary,
                  size: 32,
                ),
                title: Text(
                  l.dreams,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle: Text(l.dreamsCount(c.dreams.length)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => open(const DreamScreen()),
              ),
            ),
          ],
          if (_q.isNotEmpty && dreams.isNotEmpty) ...[
            SectionTitle(l.dreams),
            for (final d in dreams) DreamTile(d),
          ],
          if (_q.isEmpty && marks.isNotEmpty) ...[
            SectionTitle(l.bookmarks),
            for (final id in marks)
              if (c.cards[id] != null)
                ListTile(
                  title: Text(c.cards[id]!.name),
                  leading: CardFace(c.cards[id]!, width: 34),
                  trailing: const Icon(Icons.bookmark),
                  onTap: () => open(CardDetail(c.cards[id]!)),
                ),
          ],
          if (arts.isNotEmpty) SectionTitle(l.articles),
          // Horizontal shelf keeps the 78 cards on the first screen.
          if (arts.isNotEmpty)
            SizedBox(
              height: 128,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: arts.length,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (_, i) => SizedBox(
                  width: 210,
                  child: Card(
                    margin: EdgeInsets.zero,
                    child: InkWell(
                      onTap: () => open(ArticleView(arts[i])),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.auto_stories_outlined,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                            const SizedBox(height: 6),
                            Expanded(
                              child: Text(
                                arts[i].title,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (cards.isNotEmpty) SectionTitle(l.cardsCount(cards.length)),
          for (final k in cards)
            ListTile(
              leading: CardFace(k, width: 34),
              title: Text(k.name),
              subtitle: Text('${k.group} · ${k.keywords.take(3).join(', ')}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => open(CardDetail(k)),
            ),
          if (arche.isNotEmpty) ...[
            SectionTitle(l.archetypes),
            Text(
              l.archetypesNote,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          for (final a in arche)
            ListTile(
              title: Text(a.name),
              subtitle: Text(a.summary, maxLines: 2),
              onTap: () => open(ArchetypeView(a)),
            ),
          if (terms.isNotEmpty) SectionTitle(l.glossary),
          for (final t in terms)
            ExpansionTile(
              title: Text(t.term),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              children: [Text(t.definition)],
            ),
        ],
      ),
    );
  }
}

class ArticleView extends StatelessWidget {
  final Article a;
  const ArticleView(this.a, {super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(a.title)),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final p in a.body.split(RegExp(r'\n\s*\n')))
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: SelectableText(p.trim()),
          ),
      ],
    ),
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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(a.summary),
          LabeledBlock(l.archetypeGifts, Text(a.gifts)),
          LabeledBlock(l.archetypeShadow, Text(a.shadow)),
          LabeledBlock(
            l.reflectionQuestions,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [for (final q in a.reflection) Text('• $q')],
            ),
          ),
          SaveReflectionButton(
            prompt: a.reflection.first,
            ref: {'type': 'archetype', 'label': a.name, 'id': a.id},
          ),
          LabeledBlock(
            l.aboutModel,
            Text(
              l.archetypesNote,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class DreamTile extends StatelessWidget {
  final Dream d;
  const DreamTile(this.d, {super.key});
  @override
  Widget build(BuildContext context) => ExpansionTile(
    title: Text(d.symbol, style: Theme.of(context).textTheme.titleMedium),
    childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
    expandedCrossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(d.meaning),
      LabeledBlock(context.l.reflectionQuestion, Text(d.reflection)),
      SaveReflectionButton(
        prompt: d.reflection,
        ref: {'type': 'dream', 'label': '${context.l.dreams}: ${d.symbol}'},
      ),
    ],
  );
}

class DreamScreen extends StatefulWidget {
  const DreamScreen({super.key});
  @override
  State<DreamScreen> createState() => _DreamScreenState();
}

class _DreamScreenState extends State<DreamScreen> {
  String _q = '';
  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final list = context.content.dreams
        .where((d) => _q.isEmpty || d.symbol.toLowerCase().contains(_q))
        .toList();
    return Scaffold(
      appBar: AppBar(title: Text(l.dreams)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l.dreamsIntro, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 12),
          TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: l.dreamsSearch,
            ),
            onChanged: (v) => setState(() => _q = v.trim().toLowerCase()),
          ),
          if (list.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(l.dreamsEmpty),
            ),
          for (final d in list) DreamTile(d),
        ],
      ),
    );
  }
}
