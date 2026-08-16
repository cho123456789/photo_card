import 'dart:io';

import 'package:flutter/material.dart';

import '../../../domain/entities/member_binder.dart';
import '../../../domain/entities/photo_card.dart';

class BinderStatisticsPage extends StatelessWidget {
  const BinderStatisticsPage({
    super.key,
    required this.binders,
    required this.cards,
  });

  final List<MemberBinder> binders;
  final List<PhotoCard> cards;

  @override
  Widget build(BuildContext context) {
    final ownedCards = cards.where((card) => card.isOwned).toList();
    final progress = cards.isEmpty ? 0.0 : ownedCards.length / cards.length;
    final totalSpent = ownedCards.fold<double>(
      0,
      (total, card) => total + _priceOf(card),
    );
    final recentCards = [...ownedCards]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return Scaffold(
      appBar: AppBar(title: const Text('통계')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _OverviewCard(
            owned: ownedCards.length,
            total: cards.length,
            progress: progress,
            totalSpent: totalSpent,
          ),
          const SizedBox(height: 24),
          Text('바인더별 완성도', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          if (binders.isEmpty)
            const _EmptyStatistics(message: '아직 만든 컬렉션이 없어요.')
          else
            ...binders.map(
              (binder) => _BinderProgressCard(
                binder: binder,
                cards: cards
                    .where((card) => card.memberId == binder.id)
                    .toList(),
              ),
            ),
          const SizedBox(height: 24),
          Text('최근 등록 카드', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          if (recentCards.isEmpty)
            const _EmptyStatistics(message: '등록한 포토카드가 없어요.')
          else
            ...recentCards.take(5).map(_RecentCardTile.new),
        ],
      ),
    );
  }

  double _priceOf(PhotoCard card) =>
      double.tryParse(card.price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
}

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({
    required this.owned,
    required this.total,
    required this.progress,
    required this.totalSpent,
  });

  final int owned;
  final int total;
  final double progress;
  final double totalSpent;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          SizedBox(
            width: 112,
            height: 112,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(value: progress, strokeWidth: 10),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${(progress * 100).round()}%',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const Text('보유율'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('전체 보유', style: Theme.of(context).textTheme.labelLarge),
                Text('$owned / $total', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 12),
                Text('총 지출', style: Theme.of(context).textTheme.labelLarge),
                Text(
                  '${totalSpent.round().toString().replaceAllMapped(RegExp(r'(?<!^)(?=(\d{3})+$)'), (_) => ',')}원',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _BinderProgressCard extends StatelessWidget {
  const _BinderProgressCard({required this.binder, required this.cards});

  final MemberBinder binder;
  final List<PhotoCard> cards;

  @override
  Widget build(BuildContext context) {
    final owned = cards.where((card) => card.isOwned).length;
    final progress = cards.isEmpty ? 0.0 : owned / cards.length;
    final color = Color(binder.colorValue);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(binder.name, style: const TextStyle(fontWeight: FontWeight.bold))),
                Text('$owned / ${cards.length}'),
              ],
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(value: progress, color: color, minHeight: 8),
          ],
        ),
      ),
    );
  }
}

class _RecentCardTile extends StatelessWidget {
  const _RecentCardTile(this.card);

  final PhotoCard card;

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: SizedBox(
          width: 44,
          height: 58,
          child: Image.file(
            File(card.imagePath!),
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => const ColoredBox(color: Colors.black26),
          ),
        ),
      ),
      title: Text(card.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(_dateLabel(card.createdAt)),
    ),
  );

  String _dateLabel(DateTime date) =>
      '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')} 등록';
}

class _EmptyStatistics extends StatelessWidget {
  const _EmptyStatistics({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Center(child: Text(message)),
    ),
  );
}
