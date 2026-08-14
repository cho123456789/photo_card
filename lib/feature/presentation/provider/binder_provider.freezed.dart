// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'binder_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BinderState {

 List<MemberBinder> get binders; List<PhotoCard> get cards; List<String> get groupIds; String? get selectedBinderId; bool get isSaving; int get tab;
/// Create a copy of BinderState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BinderStateCopyWith<BinderState> get copyWith => _$BinderStateCopyWithImpl<BinderState>(this as BinderState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BinderState&&const DeepCollectionEquality().equals(other.binders, binders)&&const DeepCollectionEquality().equals(other.cards, cards)&&const DeepCollectionEquality().equals(other.groupIds, groupIds)&&(identical(other.selectedBinderId, selectedBinderId) || other.selectedBinderId == selectedBinderId)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.tab, tab) || other.tab == tab));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(binders),const DeepCollectionEquality().hash(cards),const DeepCollectionEquality().hash(groupIds),selectedBinderId,isSaving,tab);

@override
String toString() {
  return 'BinderState(binders: $binders, cards: $cards, groupIds: $groupIds, selectedBinderId: $selectedBinderId, isSaving: $isSaving, tab: $tab)';
}


}

/// @nodoc
abstract mixin class $BinderStateCopyWith<$Res>  {
  factory $BinderStateCopyWith(BinderState value, $Res Function(BinderState) _then) = _$BinderStateCopyWithImpl;
@useResult
$Res call({
 List<MemberBinder> binders, List<PhotoCard> cards, List<String> groupIds, String? selectedBinderId, bool isSaving, int tab
});




}
/// @nodoc
class _$BinderStateCopyWithImpl<$Res>
    implements $BinderStateCopyWith<$Res> {
  _$BinderStateCopyWithImpl(this._self, this._then);

  final BinderState _self;
  final $Res Function(BinderState) _then;

/// Create a copy of BinderState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? binders = null,Object? cards = null,Object? groupIds = null,Object? selectedBinderId = freezed,Object? isSaving = null,Object? tab = null,}) {
  return _then(_self.copyWith(
binders: null == binders ? _self.binders : binders // ignore: cast_nullable_to_non_nullable
as List<MemberBinder>,cards: null == cards ? _self.cards : cards // ignore: cast_nullable_to_non_nullable
as List<PhotoCard>,groupIds: null == groupIds ? _self.groupIds : groupIds // ignore: cast_nullable_to_non_nullable
as List<String>,selectedBinderId: freezed == selectedBinderId ? _self.selectedBinderId : selectedBinderId // ignore: cast_nullable_to_non_nullable
as String?,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,tab: null == tab ? _self.tab : tab // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BinderState].
extension BinderStatePatterns on BinderState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BinderState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BinderState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BinderState value)  $default,){
final _that = this;
switch (_that) {
case _BinderState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BinderState value)?  $default,){
final _that = this;
switch (_that) {
case _BinderState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<MemberBinder> binders,  List<PhotoCard> cards,  List<String> groupIds,  String? selectedBinderId,  bool isSaving,  int tab)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BinderState() when $default != null:
return $default(_that.binders,_that.cards,_that.groupIds,_that.selectedBinderId,_that.isSaving,_that.tab);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<MemberBinder> binders,  List<PhotoCard> cards,  List<String> groupIds,  String? selectedBinderId,  bool isSaving,  int tab)  $default,) {final _that = this;
switch (_that) {
case _BinderState():
return $default(_that.binders,_that.cards,_that.groupIds,_that.selectedBinderId,_that.isSaving,_that.tab);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<MemberBinder> binders,  List<PhotoCard> cards,  List<String> groupIds,  String? selectedBinderId,  bool isSaving,  int tab)?  $default,) {final _that = this;
switch (_that) {
case _BinderState() when $default != null:
return $default(_that.binders,_that.cards,_that.groupIds,_that.selectedBinderId,_that.isSaving,_that.tab);case _:
  return null;

}
}

}

/// @nodoc


class _BinderState implements BinderState {
  const _BinderState({required final  List<MemberBinder> binders, required final  List<PhotoCard> cards, final  List<String> groupIds = const [], this.selectedBinderId, this.isSaving = false, this.tab = 0}): _binders = binders,_cards = cards,_groupIds = groupIds;
  

 final  List<MemberBinder> _binders;
@override List<MemberBinder> get binders {
  if (_binders is EqualUnmodifiableListView) return _binders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_binders);
}

 final  List<PhotoCard> _cards;
@override List<PhotoCard> get cards {
  if (_cards is EqualUnmodifiableListView) return _cards;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cards);
}

 final  List<String> _groupIds;
@override@JsonKey() List<String> get groupIds {
  if (_groupIds is EqualUnmodifiableListView) return _groupIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_groupIds);
}

@override final  String? selectedBinderId;
@override@JsonKey() final  bool isSaving;
@override@JsonKey() final  int tab;

/// Create a copy of BinderState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BinderStateCopyWith<_BinderState> get copyWith => __$BinderStateCopyWithImpl<_BinderState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BinderState&&const DeepCollectionEquality().equals(other._binders, _binders)&&const DeepCollectionEquality().equals(other._cards, _cards)&&const DeepCollectionEquality().equals(other._groupIds, _groupIds)&&(identical(other.selectedBinderId, selectedBinderId) || other.selectedBinderId == selectedBinderId)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.tab, tab) || other.tab == tab));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_binders),const DeepCollectionEquality().hash(_cards),const DeepCollectionEquality().hash(_groupIds),selectedBinderId,isSaving,tab);

@override
String toString() {
  return 'BinderState(binders: $binders, cards: $cards, groupIds: $groupIds, selectedBinderId: $selectedBinderId, isSaving: $isSaving, tab: $tab)';
}


}

/// @nodoc
abstract mixin class _$BinderStateCopyWith<$Res> implements $BinderStateCopyWith<$Res> {
  factory _$BinderStateCopyWith(_BinderState value, $Res Function(_BinderState) _then) = __$BinderStateCopyWithImpl;
@override @useResult
$Res call({
 List<MemberBinder> binders, List<PhotoCard> cards, List<String> groupIds, String? selectedBinderId, bool isSaving, int tab
});




}
/// @nodoc
class __$BinderStateCopyWithImpl<$Res>
    implements _$BinderStateCopyWith<$Res> {
  __$BinderStateCopyWithImpl(this._self, this._then);

  final _BinderState _self;
  final $Res Function(_BinderState) _then;

/// Create a copy of BinderState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? binders = null,Object? cards = null,Object? groupIds = null,Object? selectedBinderId = freezed,Object? isSaving = null,Object? tab = null,}) {
  return _then(_BinderState(
binders: null == binders ? _self._binders : binders // ignore: cast_nullable_to_non_nullable
as List<MemberBinder>,cards: null == cards ? _self._cards : cards // ignore: cast_nullable_to_non_nullable
as List<PhotoCard>,groupIds: null == groupIds ? _self._groupIds : groupIds // ignore: cast_nullable_to_non_nullable
as List<String>,selectedBinderId: freezed == selectedBinderId ? _self.selectedBinderId : selectedBinderId // ignore: cast_nullable_to_non_nullable
as String?,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,tab: null == tab ? _self.tab : tab // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
