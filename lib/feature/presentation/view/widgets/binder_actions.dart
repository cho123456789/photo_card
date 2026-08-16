import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../../domain/entities/member_binder.dart';
import '../../../domain/entities/photo_card.dart';
import 'binder_cover.dart';

/// 멤버 생성 다이얼로그에서 받은 입력값입니다.
///
/// 다이얼로그는 입력만 수집하고, Provider 상태 변경은 다이얼로그가 닫힌 뒤
/// 화면 계층에서 처리합니다. Overlay가 제거되는 도중 상태가 바뀌는 문제를 막습니다.
class CreateBinderInput {
  const CreateBinderInput({required this.name, required this.group});

  final String name;
  final String group;
}

class CreatePhotoCardInput {
  const CreatePhotoCardInput({required this.title, required this.memo});

  final String title;
  final String memo;
}

class PhotoCardRecordInput {
  const PhotoCardRecordInput({
    required this.album,
    required this.version,
    required this.benefitSource,
    required this.acquiredAt,
    required this.price,
    required this.memo,
  });

  final String album;
  final String version;
  final String benefitSource;
  final DateTime acquiredAt;
  final String price;
  final String memo;
}

Future<PhotoCardRecordInput?> showPhotoCardRecordDialog(
  BuildContext context,
  PhotoCard card,
) async {
  final album = TextEditingController(text: card.album);
  final version = TextEditingController(text: card.version);
  final benefitSource = TextEditingController(text: card.benefitSource);
  final price = TextEditingController(text: card.price);
  final memo = TextEditingController(text: card.memo);
  var acquiredAt = card.acquiredAt ?? DateTime.now();
  final result = await showDialog<PhotoCardRecordInput>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setDialogState) => AlertDialog(
        title: const Text('카드 기록'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: album, decoration: const InputDecoration(labelText: '앨범명')),
              TextField(controller: version, decoration: const InputDecoration(labelText: '버전')),
              TextField(controller: benefitSource, decoration: const InputDecoration(labelText: '특전처 / 입수처')),
              TextField(
                controller: price,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: '가격'),
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('입수일'),
                subtitle: Text('${acquiredAt.year}.${acquiredAt.month.toString().padLeft(2, '0')}.${acquiredAt.day.toString().padLeft(2, '0')}'),
                trailing: const Icon(Icons.calendar_month_outlined),
                onTap: () async {
                  final selected = await showDatePicker(
                    context: context,
                    initialDate: acquiredAt,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (selected != null) setDialogState(() => acquiredAt = selected);
                },
              ),
              TextField(
                controller: memo,
                maxLines: 3,
                decoration: const InputDecoration(labelText: '메모'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('취소')),
          FilledButton(
            onPressed: () => Navigator.pop(
              dialogContext,
              PhotoCardRecordInput(
                album: album.text.trim(),
                version: version.text.trim(),
                benefitSource: benefitSource.text.trim(),
                acquiredAt: acquiredAt,
                price: price.text.trim(),
                memo: memo.text.trim(),
              ),
            ),
            child: const Text('저장'),
          ),
        ],
      ),
    ),
  );
  // The route's exit animation can still access these controllers after
  // showDialog completes.
  WidgetsBinding.instance.addPostFrameCallback((_) {
    album.dispose();
    version.dispose();
    benefitSource.dispose();
    price.dispose();
    memo.dispose();
  });
  return result;
}

class BinderDecorationInput {
  const BinderDecorationInput({
    required this.coverImagePath,
    required this.clearCoverImage,
    required this.coverTitle,
    required this.coverSubtitle,
    required this.themeId,
  });

  final String? coverImagePath;
  final bool clearCoverImage;
  final String coverTitle;
  final String coverSubtitle;
  final String themeId;
}

Future<BinderDecorationInput?> showBinderDecorationSheet(
  BuildContext context, {
  required MemberBinder binder,
}) async {
  final title = TextEditingController(text: binder.coverTitle ?? binder.name);
  final subtitle = TextEditingController(text: binder.coverSubtitle ?? binder.group);
  var selectedCover = binder.coverImagePath;
  var themeId = binder.themeId;
  final result = await showModalBottomSheet<BinderDecorationInput>(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) => StatefulBuilder(
      builder: (context, setSheetState) => SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + MediaQuery.viewInsetsOf(context).bottom),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('바인더 꾸미기', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                TextField(controller: title, decoration: const InputDecoration(labelText: '표지 제목')),
                TextField(controller: subtitle, decoration: const InputDecoration(labelText: '짧은 문구')),
                const SizedBox(height: 18),
                const Text('표지 사진', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () async {
                    final imagePath = await _pickBinderCoverFromGallery();
                    if (imagePath != null && context.mounted) {
                      setSheetState(() => selectedCover = imagePath);
                    }
                  },
                  icon: const Icon(Icons.photo_library_outlined),
                  label: const Text('Choose from gallery'),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 78,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      ChoiceChip(
                        label: const Text('테마만'),
                        selected: selectedCover == null,
                        onSelected: (_) => setSheetState(() => selectedCover = null),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                const Text('페이지 테마', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: BinderCover.themes.entries.map((entry) => ChoiceChip(
                    label: Text(entry.value.label),
                    selected: themeId == entry.key,
                    onSelected: (_) => setSheetState(() => themeId = entry.key),
                  )).toList(),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.pop(sheetContext, BinderDecorationInput(
                      coverImagePath: selectedCover,
                      clearCoverImage: selectedCover == null,
                      coverTitle: title.text.trim(),
                      coverSubtitle: subtitle.text.trim(),
                      themeId: themeId,
                    )),
                    child: const Text('꾸미기 저장'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
  // The bottom sheet may still be animating out when it returns.
  WidgetsBinding.instance.addPostFrameCallback((_) {
    title.dispose();
    subtitle.dispose();
  });
  return result;
}

Future<String?> _pickBinderCoverFromGallery() async {
  final picked = await ImagePicker().pickImage(
    source: ImageSource.gallery,
    imageQuality: 92,
  );
  if (picked == null) return null;

  final documents = await getApplicationDocumentsDirectory();
  final folder = Directory(
    '${documents.path}${Platform.pathSeparator}binder_covers',
  );
  if (!await folder.exists()) await folder.create(recursive: true);
  final extension = picked.path.split('.').last;
  final destination = File(
    '${folder.path}${Platform.pathSeparator}cover_${DateTime.now().millisecondsSinceEpoch}.$extension',
  );
  await File(picked.path).copy(destination.path);
  return destination.path;
}

Future<CreatePhotoCardInput?> showCreatePhotoCardDialog(
  BuildContext context,
) async {
  final title = TextEditingController();
  final version = TextEditingController();
  final memo = TextEditingController();
  final result = await showDialog<CreatePhotoCardInput>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('포토카드 등록'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: title,
            autofocus: true,
            decoration: const InputDecoration(labelText: '카드 이름'),
          ),
          TextField(
            controller: version,
            decoration: const InputDecoration(labelText: '버전 (선택)'),
          ),
          TextField(
            controller: memo,
            maxLines: 3,
            decoration: const InputDecoration(labelText: '설명 (선택)'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: () {
            final cardName = title.text.trim();
            if (cardName.isEmpty) return;
            final cardVersion = version.text.trim();
            Navigator.pop(
              dialogContext,
              CreatePhotoCardInput(
                title: cardVersion.isEmpty ? cardName : '$cardName · $cardVersion',
                memo: memo.text.trim(),
              ),
            );
          },
          child: const Text('카메라 열기'),
        ),
      ],
    ),
  );
  WidgetsBinding.instance.addPostFrameCallback((_) {
    title.dispose();
    version.dispose();
    memo.dispose();
  });
  return result;
}

/// 멤버 이름과 그룹 이름을 입력받고, 확인 시 입력값을 반환하는 다이얼로그입니다.
Future<CreateBinderInput?> showCreateBinderDialog(BuildContext context) async {
  final name = TextEditingController();
  final group = TextEditingController();
  final result = await showDialog<CreateBinderInput>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('컬렉션 만들기'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: name,
            autofocus: true,
            decoration: const InputDecoration(labelText: '컬렉션 이름'),
          ),
          TextField(
            controller: group,
            decoration: const InputDecoration(labelText: '그룹 이름 (선택)'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: () {
            final collectionName = name.text.trim();
            if (collectionName.isEmpty) return;
            // 상태를 직접 바꾸지 않고 입력값만 반환합니다.
            // Provider 갱신은 다이얼로그가 완전히 닫힌 후 호출됩니다.
            Navigator.pop(
              dialogContext,
              CreateBinderInput(
                name: collectionName,
                group: group.text.trim().isEmpty
                    ? 'MY COLLECTION'
                    : group.text.trim(),
              ),
            );
          },
          child: const Text('만들기'),
        ),
      ],
    ),
  );
  // The dialog's exit animation may still reference these controllers when
  // showDialog completes. Dispose them after that frame has finished.
  WidgetsBinding.instance.addPostFrameCallback((_) {
    name.dispose();
    group.dispose();
  });
  return result;
}

/// 촬영 이미지가 저장될 멤버의 ID를 반환하는 바텀시트입니다.
Future<String?> showMemberPicker(
  BuildContext context,
  List<MemberBinder> binders,
) => showModalBottomSheet<String>(
  context: context,
  builder: (sheetContext) => SafeArea(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('저장할 멤버를 선택하세요', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          ...binders.map(
            (binder) => ListTile(
              leading: CircleAvatar(
                backgroundColor: Color(binder.colorValue),
                child: Text(binder.name.characters.first),
              ),
              title: Text(binder.name),
              subtitle: Text(binder.group),
              trailing: const Icon(Icons.chevron_right),
              // 화면 전체 객체 대신 ID만 돌려주어 촬영 흐름이 엔티티에 덜 결합됩니다.
              onTap: () => Navigator.pop(sheetContext, binder.id),
            ),
          ),
        ],
      ),
    ),
  ),
);

Future<String?> showMissingCardPicker(
  BuildContext context,
  List<PhotoCard> cards,
) => showModalBottomSheet<String>(
  context: context,
  builder: (sheetContext) => SafeArea(
    child: ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      children: [
        Text(
          '사진을 등록할 포토카드를 선택하세요',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        ...cards
            .where((card) => !card.isOwned)
            .map(
              (card) => ListTile(
                leading: const Icon(Icons.add_photo_alternate_outlined),
                title: Text(card.title),
                subtitle: const Text('미보유'),
                onTap: () => Navigator.pop(sheetContext, card.id),
              ),
            ),
      ],
    ),
  ),
);
