// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ticket_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TicketDetailState {

 bool get isLoading; Booking? get booking; bool get cancelling; String? get errorMessage;
/// Create a copy of TicketDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TicketDetailStateCopyWith<TicketDetailState> get copyWith => _$TicketDetailStateCopyWithImpl<TicketDetailState>(this as TicketDetailState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketDetailState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.booking, booking) || other.booking == booking)&&(identical(other.cancelling, cancelling) || other.cancelling == cancelling)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,booking,cancelling,errorMessage);

@override
String toString() {
  return 'TicketDetailState(isLoading: $isLoading, booking: $booking, cancelling: $cancelling, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $TicketDetailStateCopyWith<$Res>  {
  factory $TicketDetailStateCopyWith(TicketDetailState value, $Res Function(TicketDetailState) _then) = _$TicketDetailStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, Booking? booking, bool cancelling, String? errorMessage
});


$BookingCopyWith<$Res>? get booking;

}
/// @nodoc
class _$TicketDetailStateCopyWithImpl<$Res>
    implements $TicketDetailStateCopyWith<$Res> {
  _$TicketDetailStateCopyWithImpl(this._self, this._then);

  final TicketDetailState _self;
  final $Res Function(TicketDetailState) _then;

/// Create a copy of TicketDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? booking = freezed,Object? cancelling = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,booking: freezed == booking ? _self.booking : booking // ignore: cast_nullable_to_non_nullable
as Booking?,cancelling: null == cancelling ? _self.cancelling : cancelling // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of TicketDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingCopyWith<$Res>? get booking {
    if (_self.booking == null) {
    return null;
  }

  return $BookingCopyWith<$Res>(_self.booking!, (value) {
    return _then(_self.copyWith(booking: value));
  });
}
}


/// Adds pattern-matching-related methods to [TicketDetailState].
extension TicketDetailStatePatterns on TicketDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TicketDetailState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TicketDetailState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TicketDetailState value)  $default,){
final _that = this;
switch (_that) {
case _TicketDetailState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TicketDetailState value)?  $default,){
final _that = this;
switch (_that) {
case _TicketDetailState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  Booking? booking,  bool cancelling,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TicketDetailState() when $default != null:
return $default(_that.isLoading,_that.booking,_that.cancelling,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  Booking? booking,  bool cancelling,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _TicketDetailState():
return $default(_that.isLoading,_that.booking,_that.cancelling,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  Booking? booking,  bool cancelling,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _TicketDetailState() when $default != null:
return $default(_that.isLoading,_that.booking,_that.cancelling,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _TicketDetailState implements TicketDetailState {
  const _TicketDetailState({this.isLoading = true, this.booking, this.cancelling = false, this.errorMessage});
  

@override@JsonKey() final  bool isLoading;
@override final  Booking? booking;
@override@JsonKey() final  bool cancelling;
@override final  String? errorMessage;

/// Create a copy of TicketDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TicketDetailStateCopyWith<_TicketDetailState> get copyWith => __$TicketDetailStateCopyWithImpl<_TicketDetailState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TicketDetailState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.booking, booking) || other.booking == booking)&&(identical(other.cancelling, cancelling) || other.cancelling == cancelling)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,booking,cancelling,errorMessage);

@override
String toString() {
  return 'TicketDetailState(isLoading: $isLoading, booking: $booking, cancelling: $cancelling, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$TicketDetailStateCopyWith<$Res> implements $TicketDetailStateCopyWith<$Res> {
  factory _$TicketDetailStateCopyWith(_TicketDetailState value, $Res Function(_TicketDetailState) _then) = __$TicketDetailStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, Booking? booking, bool cancelling, String? errorMessage
});


@override $BookingCopyWith<$Res>? get booking;

}
/// @nodoc
class __$TicketDetailStateCopyWithImpl<$Res>
    implements _$TicketDetailStateCopyWith<$Res> {
  __$TicketDetailStateCopyWithImpl(this._self, this._then);

  final _TicketDetailState _self;
  final $Res Function(_TicketDetailState) _then;

/// Create a copy of TicketDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? booking = freezed,Object? cancelling = null,Object? errorMessage = freezed,}) {
  return _then(_TicketDetailState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,booking: freezed == booking ? _self.booking : booking // ignore: cast_nullable_to_non_nullable
as Booking?,cancelling: null == cancelling ? _self.cancelling : cancelling // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of TicketDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingCopyWith<$Res>? get booking {
    if (_self.booking == null) {
    return null;
  }

  return $BookingCopyWith<$Res>(_self.booking!, (value) {
    return _then(_self.copyWith(booking: value));
  });
}
}

// dart format on
