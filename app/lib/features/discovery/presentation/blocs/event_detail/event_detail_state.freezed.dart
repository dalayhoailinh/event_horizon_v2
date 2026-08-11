// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EventDetailState {

 bool get isLoading; EventDetail? get detail; Failure? get failure;
/// Create a copy of EventDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventDetailStateCopyWith<EventDetailState> get copyWith => _$EventDetailStateCopyWithImpl<EventDetailState>(this as EventDetailState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventDetailState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.detail, detail) || other.detail == detail)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,detail,failure);

@override
String toString() {
  return 'EventDetailState(isLoading: $isLoading, detail: $detail, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $EventDetailStateCopyWith<$Res>  {
  factory $EventDetailStateCopyWith(EventDetailState value, $Res Function(EventDetailState) _then) = _$EventDetailStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, EventDetail? detail, Failure? failure
});


$EventDetailCopyWith<$Res>? get detail;

}
/// @nodoc
class _$EventDetailStateCopyWithImpl<$Res>
    implements $EventDetailStateCopyWith<$Res> {
  _$EventDetailStateCopyWithImpl(this._self, this._then);

  final EventDetailState _self;
  final $Res Function(EventDetailState) _then;

/// Create a copy of EventDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? detail = freezed,Object? failure = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,detail: freezed == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as EventDetail?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}
/// Create a copy of EventDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventDetailCopyWith<$Res>? get detail {
    if (_self.detail == null) {
    return null;
  }

  return $EventDetailCopyWith<$Res>(_self.detail!, (value) {
    return _then(_self.copyWith(detail: value));
  });
}
}


/// Adds pattern-matching-related methods to [EventDetailState].
extension EventDetailStatePatterns on EventDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventDetailState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventDetailState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventDetailState value)  $default,){
final _that = this;
switch (_that) {
case _EventDetailState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventDetailState value)?  $default,){
final _that = this;
switch (_that) {
case _EventDetailState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  EventDetail? detail,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventDetailState() when $default != null:
return $default(_that.isLoading,_that.detail,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  EventDetail? detail,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _EventDetailState():
return $default(_that.isLoading,_that.detail,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  EventDetail? detail,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _EventDetailState() when $default != null:
return $default(_that.isLoading,_that.detail,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _EventDetailState implements EventDetailState {
  const _EventDetailState({this.isLoading = false, this.detail, this.failure});
  

@override@JsonKey() final  bool isLoading;
@override final  EventDetail? detail;
@override final  Failure? failure;

/// Create a copy of EventDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventDetailStateCopyWith<_EventDetailState> get copyWith => __$EventDetailStateCopyWithImpl<_EventDetailState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventDetailState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.detail, detail) || other.detail == detail)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,detail,failure);

@override
String toString() {
  return 'EventDetailState(isLoading: $isLoading, detail: $detail, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$EventDetailStateCopyWith<$Res> implements $EventDetailStateCopyWith<$Res> {
  factory _$EventDetailStateCopyWith(_EventDetailState value, $Res Function(_EventDetailState) _then) = __$EventDetailStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, EventDetail? detail, Failure? failure
});


@override $EventDetailCopyWith<$Res>? get detail;

}
/// @nodoc
class __$EventDetailStateCopyWithImpl<$Res>
    implements _$EventDetailStateCopyWith<$Res> {
  __$EventDetailStateCopyWithImpl(this._self, this._then);

  final _EventDetailState _self;
  final $Res Function(_EventDetailState) _then;

/// Create a copy of EventDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? detail = freezed,Object? failure = freezed,}) {
  return _then(_EventDetailState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,detail: freezed == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as EventDetail?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

/// Create a copy of EventDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventDetailCopyWith<$Res>? get detail {
    if (_self.detail == null) {
    return null;
  }

  return $EventDetailCopyWith<$Res>(_self.detail!, (value) {
    return _then(_self.copyWith(detail: value));
  });
}
}

// dart format on
