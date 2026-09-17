// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_create_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BookingCreateState {

 Map<String, int> get quantities; bool get submitting; String? get bookingId; bool get paymentRequired; String? get errorMessage;
/// Create a copy of BookingCreateState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingCreateStateCopyWith<BookingCreateState> get copyWith => _$BookingCreateStateCopyWithImpl<BookingCreateState>(this as BookingCreateState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingCreateState&&const DeepCollectionEquality().equals(other.quantities, quantities)&&(identical(other.submitting, submitting) || other.submitting == submitting)&&(identical(other.bookingId, bookingId) || other.bookingId == bookingId)&&(identical(other.paymentRequired, paymentRequired) || other.paymentRequired == paymentRequired)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(quantities),submitting,bookingId,paymentRequired,errorMessage);

@override
String toString() {
  return 'BookingCreateState(quantities: $quantities, submitting: $submitting, bookingId: $bookingId, paymentRequired: $paymentRequired, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $BookingCreateStateCopyWith<$Res>  {
  factory $BookingCreateStateCopyWith(BookingCreateState value, $Res Function(BookingCreateState) _then) = _$BookingCreateStateCopyWithImpl;
@useResult
$Res call({
 Map<String, int> quantities, bool submitting, String? bookingId, bool paymentRequired, String? errorMessage
});




}
/// @nodoc
class _$BookingCreateStateCopyWithImpl<$Res>
    implements $BookingCreateStateCopyWith<$Res> {
  _$BookingCreateStateCopyWithImpl(this._self, this._then);

  final BookingCreateState _self;
  final $Res Function(BookingCreateState) _then;

/// Create a copy of BookingCreateState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? quantities = null,Object? submitting = null,Object? bookingId = freezed,Object? paymentRequired = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
quantities: null == quantities ? _self.quantities : quantities // ignore: cast_nullable_to_non_nullable
as Map<String, int>,submitting: null == submitting ? _self.submitting : submitting // ignore: cast_nullable_to_non_nullable
as bool,bookingId: freezed == bookingId ? _self.bookingId : bookingId // ignore: cast_nullable_to_non_nullable
as String?,paymentRequired: null == paymentRequired ? _self.paymentRequired : paymentRequired // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BookingCreateState].
extension BookingCreateStatePatterns on BookingCreateState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingCreateState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingCreateState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingCreateState value)  $default,){
final _that = this;
switch (_that) {
case _BookingCreateState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingCreateState value)?  $default,){
final _that = this;
switch (_that) {
case _BookingCreateState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, int> quantities,  bool submitting,  String? bookingId,  bool paymentRequired,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingCreateState() when $default != null:
return $default(_that.quantities,_that.submitting,_that.bookingId,_that.paymentRequired,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, int> quantities,  bool submitting,  String? bookingId,  bool paymentRequired,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _BookingCreateState():
return $default(_that.quantities,_that.submitting,_that.bookingId,_that.paymentRequired,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, int> quantities,  bool submitting,  String? bookingId,  bool paymentRequired,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _BookingCreateState() when $default != null:
return $default(_that.quantities,_that.submitting,_that.bookingId,_that.paymentRequired,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _BookingCreateState extends BookingCreateState {
  const _BookingCreateState({final  Map<String, int> quantities = const <String, int>{}, this.submitting = false, this.bookingId, this.paymentRequired = false, this.errorMessage}): _quantities = quantities,super._();
  

 final  Map<String, int> _quantities;
@override@JsonKey() Map<String, int> get quantities {
  if (_quantities is EqualUnmodifiableMapView) return _quantities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_quantities);
}

@override@JsonKey() final  bool submitting;
@override final  String? bookingId;
@override@JsonKey() final  bool paymentRequired;
@override final  String? errorMessage;

/// Create a copy of BookingCreateState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingCreateStateCopyWith<_BookingCreateState> get copyWith => __$BookingCreateStateCopyWithImpl<_BookingCreateState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingCreateState&&const DeepCollectionEquality().equals(other._quantities, _quantities)&&(identical(other.submitting, submitting) || other.submitting == submitting)&&(identical(other.bookingId, bookingId) || other.bookingId == bookingId)&&(identical(other.paymentRequired, paymentRequired) || other.paymentRequired == paymentRequired)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_quantities),submitting,bookingId,paymentRequired,errorMessage);

@override
String toString() {
  return 'BookingCreateState(quantities: $quantities, submitting: $submitting, bookingId: $bookingId, paymentRequired: $paymentRequired, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$BookingCreateStateCopyWith<$Res> implements $BookingCreateStateCopyWith<$Res> {
  factory _$BookingCreateStateCopyWith(_BookingCreateState value, $Res Function(_BookingCreateState) _then) = __$BookingCreateStateCopyWithImpl;
@override @useResult
$Res call({
 Map<String, int> quantities, bool submitting, String? bookingId, bool paymentRequired, String? errorMessage
});




}
/// @nodoc
class __$BookingCreateStateCopyWithImpl<$Res>
    implements _$BookingCreateStateCopyWith<$Res> {
  __$BookingCreateStateCopyWithImpl(this._self, this._then);

  final _BookingCreateState _self;
  final $Res Function(_BookingCreateState) _then;

/// Create a copy of BookingCreateState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? quantities = null,Object? submitting = null,Object? bookingId = freezed,Object? paymentRequired = null,Object? errorMessage = freezed,}) {
  return _then(_BookingCreateState(
quantities: null == quantities ? _self._quantities : quantities // ignore: cast_nullable_to_non_nullable
as Map<String, int>,submitting: null == submitting ? _self.submitting : submitting // ignore: cast_nullable_to_non_nullable
as bool,bookingId: freezed == bookingId ? _self.bookingId : bookingId // ignore: cast_nullable_to_non_nullable
as String?,paymentRequired: null == paymentRequired ? _self.paymentRequired : paymentRequired // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
