// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'seat_selection_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SeatSelectionState {

 bool get loading; EventDetail? get detail; List<SeatMapFloor> get floors; Map<String, SeatLock> get locks; Set<String> get selected; String? get message; String? get loadError;
/// Create a copy of SeatSelectionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SeatSelectionStateCopyWith<SeatSelectionState> get copyWith => _$SeatSelectionStateCopyWithImpl<SeatSelectionState>(this as SeatSelectionState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SeatSelectionState&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.detail, detail) || other.detail == detail)&&const DeepCollectionEquality().equals(other.floors, floors)&&const DeepCollectionEquality().equals(other.locks, locks)&&const DeepCollectionEquality().equals(other.selected, selected)&&(identical(other.message, message) || other.message == message)&&(identical(other.loadError, loadError) || other.loadError == loadError));
}


@override
int get hashCode => Object.hash(runtimeType,loading,detail,const DeepCollectionEquality().hash(floors),const DeepCollectionEquality().hash(locks),const DeepCollectionEquality().hash(selected),message,loadError);

@override
String toString() {
  return 'SeatSelectionState(loading: $loading, detail: $detail, floors: $floors, locks: $locks, selected: $selected, message: $message, loadError: $loadError)';
}


}

/// @nodoc
abstract mixin class $SeatSelectionStateCopyWith<$Res>  {
  factory $SeatSelectionStateCopyWith(SeatSelectionState value, $Res Function(SeatSelectionState) _then) = _$SeatSelectionStateCopyWithImpl;
@useResult
$Res call({
 bool loading, EventDetail? detail, List<SeatMapFloor> floors, Map<String, SeatLock> locks, Set<String> selected, String? message, String? loadError
});


$EventDetailCopyWith<$Res>? get detail;

}
/// @nodoc
class _$SeatSelectionStateCopyWithImpl<$Res>
    implements $SeatSelectionStateCopyWith<$Res> {
  _$SeatSelectionStateCopyWithImpl(this._self, this._then);

  final SeatSelectionState _self;
  final $Res Function(SeatSelectionState) _then;

/// Create a copy of SeatSelectionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loading = null,Object? detail = freezed,Object? floors = null,Object? locks = null,Object? selected = null,Object? message = freezed,Object? loadError = freezed,}) {
  return _then(_self.copyWith(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,detail: freezed == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as EventDetail?,floors: null == floors ? _self.floors : floors // ignore: cast_nullable_to_non_nullable
as List<SeatMapFloor>,locks: null == locks ? _self.locks : locks // ignore: cast_nullable_to_non_nullable
as Map<String, SeatLock>,selected: null == selected ? _self.selected : selected // ignore: cast_nullable_to_non_nullable
as Set<String>,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,loadError: freezed == loadError ? _self.loadError : loadError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of SeatSelectionState
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


/// Adds pattern-matching-related methods to [SeatSelectionState].
extension SeatSelectionStatePatterns on SeatSelectionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SeatSelectionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SeatSelectionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SeatSelectionState value)  $default,){
final _that = this;
switch (_that) {
case _SeatSelectionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SeatSelectionState value)?  $default,){
final _that = this;
switch (_that) {
case _SeatSelectionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool loading,  EventDetail? detail,  List<SeatMapFloor> floors,  Map<String, SeatLock> locks,  Set<String> selected,  String? message,  String? loadError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SeatSelectionState() when $default != null:
return $default(_that.loading,_that.detail,_that.floors,_that.locks,_that.selected,_that.message,_that.loadError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool loading,  EventDetail? detail,  List<SeatMapFloor> floors,  Map<String, SeatLock> locks,  Set<String> selected,  String? message,  String? loadError)  $default,) {final _that = this;
switch (_that) {
case _SeatSelectionState():
return $default(_that.loading,_that.detail,_that.floors,_that.locks,_that.selected,_that.message,_that.loadError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool loading,  EventDetail? detail,  List<SeatMapFloor> floors,  Map<String, SeatLock> locks,  Set<String> selected,  String? message,  String? loadError)?  $default,) {final _that = this;
switch (_that) {
case _SeatSelectionState() when $default != null:
return $default(_that.loading,_that.detail,_that.floors,_that.locks,_that.selected,_that.message,_that.loadError);case _:
  return null;

}
}

}

/// @nodoc


class _SeatSelectionState implements SeatSelectionState {
  const _SeatSelectionState({this.loading = false, this.detail, final  List<SeatMapFloor> floors = const [], final  Map<String, SeatLock> locks = const {}, final  Set<String> selected = const {}, this.message, this.loadError}): _floors = floors,_locks = locks,_selected = selected;
  

@override@JsonKey() final  bool loading;
@override final  EventDetail? detail;
 final  List<SeatMapFloor> _floors;
@override@JsonKey() List<SeatMapFloor> get floors {
  if (_floors is EqualUnmodifiableListView) return _floors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_floors);
}

 final  Map<String, SeatLock> _locks;
@override@JsonKey() Map<String, SeatLock> get locks {
  if (_locks is EqualUnmodifiableMapView) return _locks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_locks);
}

 final  Set<String> _selected;
@override@JsonKey() Set<String> get selected {
  if (_selected is EqualUnmodifiableSetView) return _selected;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_selected);
}

@override final  String? message;
@override final  String? loadError;

/// Create a copy of SeatSelectionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SeatSelectionStateCopyWith<_SeatSelectionState> get copyWith => __$SeatSelectionStateCopyWithImpl<_SeatSelectionState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SeatSelectionState&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.detail, detail) || other.detail == detail)&&const DeepCollectionEquality().equals(other._floors, _floors)&&const DeepCollectionEquality().equals(other._locks, _locks)&&const DeepCollectionEquality().equals(other._selected, _selected)&&(identical(other.message, message) || other.message == message)&&(identical(other.loadError, loadError) || other.loadError == loadError));
}


@override
int get hashCode => Object.hash(runtimeType,loading,detail,const DeepCollectionEquality().hash(_floors),const DeepCollectionEquality().hash(_locks),const DeepCollectionEquality().hash(_selected),message,loadError);

@override
String toString() {
  return 'SeatSelectionState(loading: $loading, detail: $detail, floors: $floors, locks: $locks, selected: $selected, message: $message, loadError: $loadError)';
}


}

/// @nodoc
abstract mixin class _$SeatSelectionStateCopyWith<$Res> implements $SeatSelectionStateCopyWith<$Res> {
  factory _$SeatSelectionStateCopyWith(_SeatSelectionState value, $Res Function(_SeatSelectionState) _then) = __$SeatSelectionStateCopyWithImpl;
@override @useResult
$Res call({
 bool loading, EventDetail? detail, List<SeatMapFloor> floors, Map<String, SeatLock> locks, Set<String> selected, String? message, String? loadError
});


@override $EventDetailCopyWith<$Res>? get detail;

}
/// @nodoc
class __$SeatSelectionStateCopyWithImpl<$Res>
    implements _$SeatSelectionStateCopyWith<$Res> {
  __$SeatSelectionStateCopyWithImpl(this._self, this._then);

  final _SeatSelectionState _self;
  final $Res Function(_SeatSelectionState) _then;

/// Create a copy of SeatSelectionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loading = null,Object? detail = freezed,Object? floors = null,Object? locks = null,Object? selected = null,Object? message = freezed,Object? loadError = freezed,}) {
  return _then(_SeatSelectionState(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,detail: freezed == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as EventDetail?,floors: null == floors ? _self._floors : floors // ignore: cast_nullable_to_non_nullable
as List<SeatMapFloor>,locks: null == locks ? _self._locks : locks // ignore: cast_nullable_to_non_nullable
as Map<String, SeatLock>,selected: null == selected ? _self._selected : selected // ignore: cast_nullable_to_non_nullable
as Set<String>,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,loadError: freezed == loadError ? _self.loadError : loadError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of SeatSelectionState
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
