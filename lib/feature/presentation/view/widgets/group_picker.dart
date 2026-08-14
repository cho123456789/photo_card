import 'package:flutter/material.dart';

import '../../../domain/catalog/group_catalog.dart';

class GroupPicker extends StatelessWidget {
  const GroupPicker({super.key, required this.onSelect});

  final ValueChanged<GroupCatalog> onSelect;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(24),
    children: [
      const SizedBox(height: 40),
      Text('어떤 그룹을 수집하나요?', style: Theme.of(context).textTheme.headlineSmall),
      const SizedBox(height: 8),
      const Text('그룹을 선택하면 공식 앨범·포토카드 카탈로그를 내 컬렉션에 추가합니다.'),
      const SizedBox(height: 28),
      ...GroupCatalog.available.map(
        (catalog) => Card(
          child: ListTile(
            contentPadding: const EdgeInsets.all(18),
            leading: CircleAvatar(
              backgroundColor: Color(catalog.colorValue),
              child: const Icon(Icons.groups),
            ),
            title: Text(
              catalog.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('카탈로그 사용 가능'),
            trailing: const Icon(Icons.add_circle_outline),
            onTap: () => onSelect(catalog),
          ),
        ),
      ),
      const SizedBox(height: 12),
      const Text(
        '다른 그룹 카탈로그는 순차적으로 추가됩니다.',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white54),
      ),
    ],
  );
}
