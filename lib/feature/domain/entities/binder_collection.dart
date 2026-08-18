import 'member_binder.dart';
import 'photo_card.dart';

class BinderCollection {
  const BinderCollection({
    required this.binders,
    required this.cards,
  });

  final List<MemberBinder> binders;
  final List<PhotoCard> cards;
}
