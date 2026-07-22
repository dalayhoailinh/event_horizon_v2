// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EventDetail {

 EventSummary get summary; DateTime get endAt; String get venueAddress; String get organizerName; String get descriptionPlain; List<String> get galleryUrls; List<TicketTypeInfo> get ticketTypes;
/// Create a copy of EventDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventDetailCopyWith<EventDetail> get copyWith => _$EventDetailCopyWithImpl<EventDetail>(this as EventDetail, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventDetail&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.endAt, endAt) || other.endAt == endAt)&&(identical(other.venueAddress, venueAddress) || other.venueAddress == venueAddress)&&(identical(other.organizerName, organizerName) || other.organizerName == organizerName)&&(identical(other.descriptionPlain, descriptionPlain) || other.descriptionPlain == descriptionPlain)&&const DeepCollectionEquality().equals(other.galleryUrls, galleryUrls)&&const DeepCollectionEquality().equals(other.ticketTypes, ticketTypes));
}


@override
int get hashCode => Object.hash(runtimeType,summary,endAt,venueAddress,organizerName,descriptionPlain,const DeepCollectionEquality().hash(galleryUrls),const DeepCollectionEquality().hash(ticketTypes));

@override
String toString() {
  return 'EventDetail(summary: $summary, endAt: $endAt, venueAddress: $venueAddress, organizerName: $organizerName, descriptionPlain: $descriptionPlain, galleryUrls: $galleryUrls, ticketTypes: $ticketTypes)';
}


}

/// @nodoc
abstract mixin class $EventDetailCopyWith<$Res>  {
  factory $EventDetailCopyWith(EventDetail value, $Res Function(EventDetail) _then) = _$EventDetailCopyWithImpl;
@useResult
$Res call({
 EventSummary summary, DateTime endAt, String venueAddress, String organizerName, String descriptionPlain, List<String> galleryUrls, List<TicketTypeInfo> ticketTypes
});


$EventSummaryCopyWith<$Res> get summary;

}
/// @nodoc
class _$EventDetailCopyWithImpl<$Res>
    implements $EventDetailCopyWith<$Res> {
  _$EventDetailCopyWithImpl(this._self, this._then);

  final EventDetail _self;
  final $Res Function(EventDetail) _then;

/// Create a copy of EventDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? summary = null,Object? endAt = null,Object? venueAddress = null,Object? organizerName = null,Object? descriptionPlain = null,Object? galleryUrls = null,Object? ticketTypes = null,}) {
  return _then(_self.copyWith(
summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as EventSummary,endAt: null == endAt ? _self.endAt : endAt // ignore: cast_nullable_to_non_nullable
as DateTime,venueAddress: null == venueAddress ? _self.venueAddress : venueAddress // ignore: cast_nullable_to_non_nullable
as String,organizerName: null == organizerName ? _self.organizerName : organizerName // ignore: cast_nullable_to_non_nullable
as String,descriptionPlain: null == descriptionPlain ? _self.descriptionPlain : descriptionPlain // ignore: cast_nullable_to_non_nullable
as String,galleryUrls: null == galleryUrls ? _self.galleryUrls : galleryUrls // ignore: cast_nullable_to_non_nullable
as List<String>,ticketTypes: null == ticketTypes ? _self.ticketTypes : ticketTypes // ignore: cast_nullable_to_non_nullable
as List<TicketTypeInfo>,
  ));
}
/// Create a copy of EventDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventSummaryCopyWith<$Res> get summary {
  
  return $EventSummaryCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}


/// Adds pattern-matching-related methods to [EventDetail].
extension EventDetailPatterns on EventDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventDetail value)  $default,){
final _that = this;
switch (_that) {
case _EventDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventDetail value)?  $default,){
final _that = this;
switch (_that) {
case _EventDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( EventSummary summary,  DateTime endAt,  String venueAddress,  String organizerName,  String descriptionPlain,  List<String> galleryUrls,  List<TicketTypeInfo> ticketTypes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventDetail() when $default != null:
return $default(_that.summary,_that.endAt,_that.venueAddress,_that.organizerName,_that.descriptionPlain,_that.galleryUrls,_that.ticketTypes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( EventSummary summary,  DateTime endAt,  String venueAddress,  String organizerName,  String descriptionPlain,  List<String> galleryUrls,  List<TicketTypeInfo> ticketTypes)  $default,) {final _that = this;
switch (_that) {
case _EventDetail():
return $default(_that.summary,_that.endAt,_that.venueAddress,_that.organizerName,_that.descriptionPlain,_that.galleryUrls,_that.ticketTypes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( EventSummary summary,  DateTime endAt,  String venueAddress,  String organizerName,  String descriptionPlain,  List<String> galleryUrls,  List<TicketTypeInfo> ticketTypes)?  $default,) {final _that = this;
switch (_that) {
case _EventDetail() when $default != null:
return $default(_that.summary,_that.endAt,_that.venueAddress,_that.organizerName,_that.descriptionPlain,_that.galleryUrls,_that.ticketTypes);case _:
  return null;

}
}

}

/// @nodoc


class _EventDetail implements EventDetail {
  const _EventDetail({required this.summary, required this.endAt, required this.venueAddress, required this.organizerName, required this.descriptionPlain, required final  List<String> galleryUrls, required final  List<TicketTypeInfo> ticketTypes}): _galleryUrls = galleryUrls,_ticketTypes = ticketTypes;
  

@override final  EventSummary summary;
@override final  DateTime endAt;
@override final  String venueAddress;
@override final  String organizerName;
@override final  String descriptionPlain;
 final  List<String> _galleryUrls;
@override List<String> get galleryUrls {
  if (_galleryUrls is EqualUnmodifiableListView) return _galleryUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_galleryUrls);
}

 final  List<TicketTypeInfo> _ticketTypes;
@override List<TicketTypeInfo> get ticketTypes {
  if (_ticketTypes is EqualUnmodifiableListView) return _ticketTypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ticketTypes);
}


/// Create a copy of EventDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventDetailCopyWith<_EventDetail> get copyWith => __$EventDetailCopyWithImpl<_EventDetail>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventDetail&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.endAt, endAt) || other.endAt == endAt)&&(identical(other.venueAddress, venueAddress) || other.venueAddress == venueAddress)&&(identical(other.organizerName, organizerName) || other.organizerName == organizerName)&&(identical(other.descriptionPlain, descriptionPlain) || other.descriptionPlain == descriptionPlain)&&const DeepCollectionEquality().equals(other._galleryUrls, _galleryUrls)&&const DeepCollectionEquality().equals(other._ticketTypes, _ticketTypes));
}


@override
int get hashCode => Object.hash(runtimeType,summary,endAt,venueAddress,organizerName,descriptionPlain,const DeepCollectionEquality().hash(_galleryUrls),const DeepCollectionEquality().hash(_ticketTypes));

@override
String toString() {
  return 'EventDetail(summary: $summary, endAt: $endAt, venueAddress: $venueAddress, organizerName: $organizerName, descriptionPlain: $descriptionPlain, galleryUrls: $galleryUrls, ticketTypes: $ticketTypes)';
}


}

/// @nodoc
abstract mixin class _$EventDetailCopyWith<$Res> implements $EventDetailCopyWith<$Res> {
  factory _$EventDetailCopyWith(_EventDetail value, $Res Function(_EventDetail) _then) = __$EventDetailCopyWithImpl;
@override @useResult
$Res call({
 EventSummary summary, DateTime endAt, String venueAddress, String organizerName, String descriptionPlain, List<String> galleryUrls, List<TicketTypeInfo> ticketTypes
});


@override $EventSummaryCopyWith<$Res> get summary;

}
/// @nodoc
class __$EventDetailCopyWithImpl<$Res>
    implements _$EventDetailCopyWith<$Res> {
  __$EventDetailCopyWithImpl(this._self, this._then);

  final _EventDetail _self;
  final $Res Function(_EventDetail) _then;

/// Create a copy of EventDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? summary = null,Object? endAt = null,Object? venueAddress = null,Object? organizerName = null,Object? descriptionPlain = null,Object? galleryUrls = null,Object? ticketTypes = null,}) {
  return _then(_EventDetail(
summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as EventSummary,endAt: null == endAt ? _self.endAt : endAt // ignore: cast_nullable_to_non_nullable
as DateTime,venueAddress: null == venueAddress ? _self.venueAddress : venueAddress // ignore: cast_nullable_to_non_nullable
as String,organizerName: null == organizerName ? _self.organizerName : organizerName // ignore: cast_nullable_to_non_nullable
as String,descriptionPlain: null == descriptionPlain ? _self.descriptionPlain : descriptionPlain // ignore: cast_nullable_to_non_nullable
as String,galleryUrls: null == galleryUrls ? _self._galleryUrls : galleryUrls // ignore: cast_nullable_to_non_nullable
as List<String>,ticketTypes: null == ticketTypes ? _self._ticketTypes : ticketTypes // ignore: cast_nullable_to_non_nullable
as List<TicketTypeInfo>,
  ));
}

/// Create a copy of EventDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventSummaryCopyWith<$Res> get summary {
  
  return $EventSummaryCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}

/// @nodoc
mixin _$TicketTypeInfo {

 String get id; String get name; String get description; int get price; int get remaining; bool get isActive;
/// Create a copy of TicketTypeInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TicketTypeInfoCopyWith<TicketTypeInfo> get copyWith => _$TicketTypeInfoCopyWithImpl<TicketTypeInfo>(this as TicketTypeInfo, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketTypeInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.price, price) || other.price == price)&&(identical(other.remaining, remaining) || other.remaining == remaining)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,description,price,remaining,isActive);

@override
String toString() {
  return 'TicketTypeInfo(id: $id, name: $name, description: $description, price: $price, remaining: $remaining, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $TicketTypeInfoCopyWith<$Res>  {
  factory $TicketTypeInfoCopyWith(TicketTypeInfo value, $Res Function(TicketTypeInfo) _then) = _$TicketTypeInfoCopyWithImpl;
@useResult
$Res call({
 String id, String name, String description, int price, int remaining, bool isActive
});




}
/// @nodoc
class _$TicketTypeInfoCopyWithImpl<$Res>
    implements $TicketTypeInfoCopyWith<$Res> {
  _$TicketTypeInfoCopyWithImpl(this._self, this._then);

  final TicketTypeInfo _self;
  final $Res Function(TicketTypeInfo) _then;

/// Create a copy of TicketTypeInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? price = null,Object? remaining = null,Object? isActive = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,remaining: null == remaining ? _self.remaining : remaining // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TicketTypeInfo].
extension TicketTypeInfoPatterns on TicketTypeInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TicketTypeInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TicketTypeInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TicketTypeInfo value)  $default,){
final _that = this;
switch (_that) {
case _TicketTypeInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TicketTypeInfo value)?  $default,){
final _that = this;
switch (_that) {
case _TicketTypeInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String description,  int price,  int remaining,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TicketTypeInfo() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.price,_that.remaining,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String description,  int price,  int remaining,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _TicketTypeInfo():
return $default(_that.id,_that.name,_that.description,_that.price,_that.remaining,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String description,  int price,  int remaining,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _TicketTypeInfo() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.price,_that.remaining,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc


class _TicketTypeInfo implements TicketTypeInfo {
  const _TicketTypeInfo({required this.id, required this.name, required this.description, required this.price, required this.remaining, required this.isActive});
  

@override final  String id;
@override final  String name;
@override final  String description;
@override final  int price;
@override final  int remaining;
@override final  bool isActive;

/// Create a copy of TicketTypeInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TicketTypeInfoCopyWith<_TicketTypeInfo> get copyWith => __$TicketTypeInfoCopyWithImpl<_TicketTypeInfo>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TicketTypeInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.price, price) || other.price == price)&&(identical(other.remaining, remaining) || other.remaining == remaining)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,description,price,remaining,isActive);

@override
String toString() {
  return 'TicketTypeInfo(id: $id, name: $name, description: $description, price: $price, remaining: $remaining, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$TicketTypeInfoCopyWith<$Res> implements $TicketTypeInfoCopyWith<$Res> {
  factory _$TicketTypeInfoCopyWith(_TicketTypeInfo value, $Res Function(_TicketTypeInfo) _then) = __$TicketTypeInfoCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String description, int price, int remaining, bool isActive
});




}
/// @nodoc
class __$TicketTypeInfoCopyWithImpl<$Res>
    implements _$TicketTypeInfoCopyWith<$Res> {
  __$TicketTypeInfoCopyWithImpl(this._self, this._then);

  final _TicketTypeInfo _self;
  final $Res Function(_TicketTypeInfo) _then;

/// Create a copy of TicketTypeInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? price = null,Object? remaining = null,Object? isActive = null,}) {
  return _then(_TicketTypeInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,remaining: null == remaining ? _self.remaining : remaining // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
