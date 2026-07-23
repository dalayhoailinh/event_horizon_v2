// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'discovery_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DiscoveryListState {

 EventFilter get filter; List<EventSummary> get events; List<EventCategory> get categories; bool get isLoading; bool get isLoadingMore; Failure? get failure; EventCursor? get cursor;
/// Create a copy of DiscoveryListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiscoveryListStateCopyWith<DiscoveryListState> get copyWith => _$DiscoveryListStateCopyWithImpl<DiscoveryListState>(this as DiscoveryListState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiscoveryListState&&(identical(other.filter, filter) || other.filter == filter)&&const DeepCollectionEquality().equals(other.events, events)&&const DeepCollectionEquality().equals(other.categories, categories)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.cursor, cursor) || other.cursor == cursor));
}


@override
int get hashCode => Object.hash(runtimeType,filter,const DeepCollectionEquality().hash(events),const DeepCollectionEquality().hash(categories),isLoading,isLoadingMore,failure,cursor);

@override
String toString() {
  return 'DiscoveryListState(filter: $filter, events: $events, categories: $categories, isLoading: $isLoading, isLoadingMore: $isLoadingMore, failure: $failure, cursor: $cursor)';
}


}

/// @nodoc
abstract mixin class $DiscoveryListStateCopyWith<$Res>  {
  factory $DiscoveryListStateCopyWith(DiscoveryListState value, $Res Function(DiscoveryListState) _then) = _$DiscoveryListStateCopyWithImpl;
@useResult
$Res call({
 EventFilter filter, List<EventSummary> events, List<EventCategory> categories, bool isLoading, bool isLoadingMore, Failure? failure, EventCursor? cursor
});


$EventFilterCopyWith<$Res> get filter;

}
/// @nodoc
class _$DiscoveryListStateCopyWithImpl<$Res>
    implements $DiscoveryListStateCopyWith<$Res> {
  _$DiscoveryListStateCopyWithImpl(this._self, this._then);

  final DiscoveryListState _self;
  final $Res Function(DiscoveryListState) _then;

/// Create a copy of DiscoveryListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? filter = null,Object? events = null,Object? categories = null,Object? isLoading = null,Object? isLoadingMore = null,Object? failure = freezed,Object? cursor = freezed,}) {
  return _then(_self.copyWith(
filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as EventFilter,events: null == events ? _self.events : events // ignore: cast_nullable_to_non_nullable
as List<EventSummary>,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<EventCategory>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,cursor: freezed == cursor ? _self.cursor : cursor // ignore: cast_nullable_to_non_nullable
as EventCursor?,
  ));
}
/// Create a copy of DiscoveryListState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventFilterCopyWith<$Res> get filter {
  
  return $EventFilterCopyWith<$Res>(_self.filter, (value) {
    return _then(_self.copyWith(filter: value));
  });
}
}


/// Adds pattern-matching-related methods to [DiscoveryListState].
extension DiscoveryListStatePatterns on DiscoveryListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiscoveryListState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiscoveryListState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiscoveryListState value)  $default,){
final _that = this;
switch (_that) {
case _DiscoveryListState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiscoveryListState value)?  $default,){
final _that = this;
switch (_that) {
case _DiscoveryListState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( EventFilter filter,  List<EventSummary> events,  List<EventCategory> categories,  bool isLoading,  bool isLoadingMore,  Failure? failure,  EventCursor? cursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiscoveryListState() when $default != null:
return $default(_that.filter,_that.events,_that.categories,_that.isLoading,_that.isLoadingMore,_that.failure,_that.cursor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( EventFilter filter,  List<EventSummary> events,  List<EventCategory> categories,  bool isLoading,  bool isLoadingMore,  Failure? failure,  EventCursor? cursor)  $default,) {final _that = this;
switch (_that) {
case _DiscoveryListState():
return $default(_that.filter,_that.events,_that.categories,_that.isLoading,_that.isLoadingMore,_that.failure,_that.cursor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( EventFilter filter,  List<EventSummary> events,  List<EventCategory> categories,  bool isLoading,  bool isLoadingMore,  Failure? failure,  EventCursor? cursor)?  $default,) {final _that = this;
switch (_that) {
case _DiscoveryListState() when $default != null:
return $default(_that.filter,_that.events,_that.categories,_that.isLoading,_that.isLoadingMore,_that.failure,_that.cursor);case _:
  return null;

}
}

}

/// @nodoc


class _DiscoveryListState extends DiscoveryListState {
  const _DiscoveryListState({this.filter = const EventFilter(), final  List<EventSummary> events = const [], final  List<EventCategory> categories = const [], this.isLoading = true, this.isLoadingMore = false, this.failure, this.cursor}): _events = events,_categories = categories,super._();
  

@override@JsonKey() final  EventFilter filter;
 final  List<EventSummary> _events;
@override@JsonKey() List<EventSummary> get events {
  if (_events is EqualUnmodifiableListView) return _events;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_events);
}

 final  List<EventCategory> _categories;
@override@JsonKey() List<EventCategory> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isLoadingMore;
@override final  Failure? failure;
@override final  EventCursor? cursor;

/// Create a copy of DiscoveryListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiscoveryListStateCopyWith<_DiscoveryListState> get copyWith => __$DiscoveryListStateCopyWithImpl<_DiscoveryListState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiscoveryListState&&(identical(other.filter, filter) || other.filter == filter)&&const DeepCollectionEquality().equals(other._events, _events)&&const DeepCollectionEquality().equals(other._categories, _categories)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.cursor, cursor) || other.cursor == cursor));
}


@override
int get hashCode => Object.hash(runtimeType,filter,const DeepCollectionEquality().hash(_events),const DeepCollectionEquality().hash(_categories),isLoading,isLoadingMore,failure,cursor);

@override
String toString() {
  return 'DiscoveryListState(filter: $filter, events: $events, categories: $categories, isLoading: $isLoading, isLoadingMore: $isLoadingMore, failure: $failure, cursor: $cursor)';
}


}

/// @nodoc
abstract mixin class _$DiscoveryListStateCopyWith<$Res> implements $DiscoveryListStateCopyWith<$Res> {
  factory _$DiscoveryListStateCopyWith(_DiscoveryListState value, $Res Function(_DiscoveryListState) _then) = __$DiscoveryListStateCopyWithImpl;
@override @useResult
$Res call({
 EventFilter filter, List<EventSummary> events, List<EventCategory> categories, bool isLoading, bool isLoadingMore, Failure? failure, EventCursor? cursor
});


@override $EventFilterCopyWith<$Res> get filter;

}
/// @nodoc
class __$DiscoveryListStateCopyWithImpl<$Res>
    implements _$DiscoveryListStateCopyWith<$Res> {
  __$DiscoveryListStateCopyWithImpl(this._self, this._then);

  final _DiscoveryListState _self;
  final $Res Function(_DiscoveryListState) _then;

/// Create a copy of DiscoveryListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? filter = null,Object? events = null,Object? categories = null,Object? isLoading = null,Object? isLoadingMore = null,Object? failure = freezed,Object? cursor = freezed,}) {
  return _then(_DiscoveryListState(
filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as EventFilter,events: null == events ? _self._events : events // ignore: cast_nullable_to_non_nullable
as List<EventSummary>,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<EventCategory>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,cursor: freezed == cursor ? _self.cursor : cursor // ignore: cast_nullable_to_non_nullable
as EventCursor?,
  ));
}

/// Create a copy of DiscoveryListState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventFilterCopyWith<$Res> get filter {
  
  return $EventFilterCopyWith<$Res>(_self.filter, (value) {
    return _then(_self.copyWith(filter: value));
  });
}
}

// dart format on
