import 'package:freezed_annotation/freezed_annotation.dart';

part 'member_model.freezed.dart';
part 'member_model.g.dart';

@freezed
abstract class MemberModel with _$MemberModel {
  const factory MemberModel({
    required int id,
    @JsonKey(name: 'member_name') required String memberName,
    @JsonKey(name: 'image_url')
    @Default([]) List<String> imageUrls,
  }) = _MemberModel;

  factory MemberModel.fromJson(Map<String, dynamic> json) =>
      _$MemberModelFromJson(json);
}