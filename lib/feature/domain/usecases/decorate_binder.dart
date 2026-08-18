import '../entities/member_binder.dart';

class DecorateBinder {
  const DecorateBinder();

  List<MemberBinder> call({
    required List<MemberBinder> binders,
    required String binderId,
    String? coverImagePath,
    required bool clearCoverImage,
    required String coverTitle,
    required String coverSubtitle,
    required String themeId,
  }) =>
      binders
          .map(
            (binder) => binder.id == binderId
                ? binder.copyWith(
                    coverImagePath: coverImagePath,
                    clearCoverImage: clearCoverImage,
                    coverTitle: coverTitle,
                    coverSubtitle: coverSubtitle,
                    themeId: themeId,
                  )
                : binder,
          )
          .toList();
}
