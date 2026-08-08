// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'member_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MemberModel {

 int get id;@JsonKey(name: 'member_name') String get memberName;@JsonKey(name: 'image_url') List<String> get imageUrls;
/// Create a copy of MemberModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemberModelCopyWith<MemberModel> get copyWith => _$MemberModelCopyWithImpl<MemberModel>(this as MemberModel, _$identity);

  /// Serializes this MemberModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemberModel&&(identical(other.id, id) || other.id == id)&&(identical(other.memberName, memberName) || other.memberName == memberName)&&const DeepCollectionEquality().equals(other.imageUrls, imageUrls));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,memberName,const DeepCollectionEquality().hash(imageUrls));

@override
String toString() {
  return 'MemberModel(id: $id, memberName: $memberName, imageUrls: $imageUrls)';
}


}

/// @nodoc
abstract mixin class $MemberModelCopyWith<$Res>  {
  factory $MemberModelCopyWith(MemberModel value, $Res Function(MemberModel) _then) = _$MemberModelCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'member_name') String memberName,@JsonKey(name: 'image_url') List<String> imageUrls
});




}
/// @nodoc
class _$MemberModelCopyWithImpl<$Res>
    implements $MemberModelCopyWith<$Res> {
  _$MemberModelCopyWithImpl(this._self, this._then);

  final MemberModel _self;
  final $Res Function(MemberModel) _then;

/// Create a copy of MemberModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? memberName = null,Object? imageUrls = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,memberName: null == memberName ? _self.memberName : memberName // ignore: cast_nullable_to_non_nullable
as String,imageUrls: null == imageUrls ? _self.imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [MemberModel].
extension MemberModelPatterns on MemberModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MemberModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MemberModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MemberModel value)  $default,){
final _that = this;
switch (_that) {
case _MemberModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MemberModel value)?  $default,){
final _that = this;
switch (_that) {
case _MemberModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'member_name')  String memberName, @JsonKey(name: 'image_url')  List<String> imageUrls)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MemberModel() when $default != null:
return $default(_that.id,_that.memberName,_that.imageUrls);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'member_name')  String memberName, @JsonKey(name: 'image_url')  List<String> imageUrls)  $default,) {final _that = this;
switch (_that) {
case _MemberModel():
return $default(_that.id,_that.memberName,_that.imageUrls);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'member_name')  String memberName, @JsonKey(name: 'image_url')  List<String> imageUrls)?  $default,) {final _that = this;
switch (_that) {
case _MemberModel() when $default != null:
return $default(_that.id,_that.memberName,_that.imageUrls);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MemberModel implements MemberModel {
  const _MemberModel({required this.id, @JsonKey(name: 'member_name') required this.memberName, @JsonKey(name: 'image_url') final  List<String> imageUrls = const []}): _imageUrls = imageUrls;
  factory _MemberModel.fromJson(Map<String, dynamic> json) => _$MemberModelFromJson(json);

@override final  int id;
@override@JsonKey(name: 'member_name') final  String memberName;
 final  List<String> _imageUrls;
@override@JsonKey(name: 'image_url') List<String> get imageUrls {
  if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_imageUrls);
}


/// Create a copy of MemberModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemberModelCopyWith<_MemberModel> get copyWith => __$MemberModelCopyWithImpl<_MemberModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MemberModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemberModel&&(identical(other.id, id) || other.id == id)&&(identical(other.memberName, memberName) || other.memberName == memberName)&&const DeepCollectionEquality().equals(other._imageUrls, _imageUrls));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,memberName,const DeepCollectionEquality().hash(_imageUrls));

@override
String toString() {
  return 'MemberModel(id: $id, memberName: $memberName, imageUrls: $imageUrls)';
}


}

/// @nodoc
abstract mixin class _$MemberModelCopyWith<$Res> implements $MemberModelCopyWith<$Res> {
  factory _$MemberModelCopyWith(_MemberModel value, $Res Function(_MemberModel) _then) = __$MemberModelCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'member_name') String memberName,@JsonKey(name: 'image_url') List<String> imageUrls
});




}
/// @nodoc
class __$MemberModelCopyWithImpl<$Res>
    implements _$MemberModelCopyWith<$Res> {
  __$MemberModelCopyWithImpl(this._self, this._then);

  final _MemberModel _self;
  final $Res Function(_MemberModel) _then;

/// Create a copy of MemberModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? memberName = null,Object? imageUrls = null,}) {
  return _then(_MemberModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,memberName: null == memberName ? _self.memberName : memberName // ignore: cast_nullable_to_non_nullable
as String,imageUrls: null == imageUrls ? _self._imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
