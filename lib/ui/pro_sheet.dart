import 'package:flutter/material.dart';

import 'widgets.dart';

/// What Pro gives, price from the store, buy + restore. No countdowns, no pressure.
Future<void> showProSheet(BuildContext context) => showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (_) => const _ProSheet(),
);

class _ProSheet extends StatelessWidget {
  const _ProSheet();

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final m = context.monetization;
    final pro = context.store.isPro;
    final body = Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.proTitle, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Text(l.proBenefits),
          const SizedBox(height: 8),
          Text(l.proFreeStays, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 16),
          if (pro)
            Text(l.proActive, style: Theme.of(context).textTheme.titleMedium)
          else if (m?.product == null)
            Text(l.proUnavailable)
          else
            FilledButton(
              onPressed: m!.buyPro,
              child: Text(l.proBuy(m.product!.price)),
            ),
          if (m?.lastError != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                l.purchaseError,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          if (m != null && !pro)
            TextButton(onPressed: m.restore, child: Text(l.restorePurchases)),
        ],
      ),
    );
    return SafeArea(
      child: m == null
          ? body
          : ListenableBuilder(listenable: m, builder: (_, _) => body),
    );
  }
}
