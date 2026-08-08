import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/models/member_model.dart';

final memberViewModelProvider =
AsyncNotifierProvider<MemberViewModel, List<MemberModel>>(
  MemberViewModel.new,
);

const tableNames = [
  'liv_images',
  'mei_images',
  'jena_images',
  'woni_images',
  'minami_images',
];

class MemberViewModel extends AsyncNotifier<List<MemberModel>> {
  @override
  Future<List<MemberModel>> build() async {
    return fetchMembers();
  }

  Future<List<MemberModel>> fetchMembers() async {
    final results = await Future.wait(
      tableNames.map((tableName) async {
        final rows = await Supabase.instance.client
            .from(tableName)
            .select('id, member_name, image_url');

        return rows
            .map((row) => Map<String, dynamic>.from(row))
            .toList();
      }),
    );

    return results
        .expand((rows) => rows)
        .map(MemberModel.fromJson)
        .toList();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(fetchMembers);
  }
}