import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodel/model_viewmodel.dart';

class MemberQuizPage extends ConsumerWidget {
  const MemberQuizPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final members = ref.watch(memberViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('멤버 맞추기')),
      body: members.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('멤버 정보를 불러오지 못했습니다.\n$error'),
          ),
        ),
        data: (memberList) {
          const memberSections = {
            'liv_images': 'Liv',
            'mei': 'Mei',
            'jena': 'Jena',
            'woni': 'Woni',
            'minami': 'Minami',
          };

          return RefreshIndicator(
            onRefresh: () =>
                ref.read(memberViewModelProvider.notifier).refresh(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: memberSections.entries.map((entry) {
                final tableName = entry.key;
                final memberName = entry.value;

                final membersForSection = memberList
                    .where((member) => member.memberName == tableName)
                    .toList();

                final imageUrls = membersForSection
                    .expand((member) => member.imageUrls)
                    .toList();

                return Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        memberName,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 12),

                      if (imageUrls.isEmpty)
                        const SizedBox(
                          height: 80,
                          child: Center(child: Text('등록된 이미지가 없습니다.')),
                        )
                      else
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: imageUrls.length,
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemBuilder: (context, imageIndex) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                imageUrls[imageIndex],
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => const ColoredBox(
                                  color: Colors.black12,
                                  child: Center(
                                    child: Icon(Icons.broken_image),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
