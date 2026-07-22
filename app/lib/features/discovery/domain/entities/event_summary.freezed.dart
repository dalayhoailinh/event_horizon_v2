// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EventSummary {

 String get id; String get title; String get coverImageUrl; DateTime get startAt; String get venueName; String get provinceCode; List<String> get categoryNames; int get minPrice; int get maxPrice; int get ticketSold; int get favoriteCount; bool get hasSeatMap;
/// Create a copy of EventSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventSummaryCopyWith<EventSummary> get copyWith => _$EventSummaryCopyWithImpl<EventSummary>(this as EventSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.coverImageUrl, coverImageUrl) || other.coverImageUrl == coverImageUrl)&&(identical(other.startAt, startAt) || other.startAt == startAt)&&(identical(other.venueName, venueName) || other.venueName == venueName)&&(identical(other.provinceCode, provinceCode) || other.provinceCode == provinceCode)&&const DeepCollectionEquality().equals(other.categoryNames, categoryNames)&&(identical(other.minPrice, minPrice) || other.minPrice == minPrice)&&(identical(other.maxPrice, maxPrice) || other.maxPrice == maxPrice)&&(identical(other.ticketSold, ticketSold) || other.ticketSold == ticketSold)&&(identical(other.favoriteCount, favoriteCount) || other.favoriteCount == favoriteCount)&&(identical(other.hasSeatMap, hasSeatMap) || other.hasSeatMap == hasSeatMap));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,coverImageUrl,startAt,venueName,provinceCode,const DeepCollectionEquality().hash(categoryNames),minPrice,maxPrice,ticketSold,favoriteCount,hasSeatMap);

@override
String toString() {
  return 'EventSummary(id: $id, title: $title, coverImageUrl: $coverImageUrl, startAt: $startAt, venueName: $venueName, provinceCode: $provinceCode, categoryNames: $categoryNames, minPrice: $minPrice, maxPrice: $maxPrice, ticketSold: $ticketSold, favoriteCount: $favoriteCount, hasSeatMap: $hasSeatMap)';
}


}

/// @nodoc
abstract mixin class $EventSummaryCopyWith<$Res>  {
  factory $EventSummaryCopyWith(EventSummary value, $Res Function(EventSummary) _then) = _$EventSummaryCopyWithImpl;
@useResult
$Res call({
 String id, String title, String coverImageUrl, DateTime startAt, String venueName, String provinceCode, List<String> categoryNames, int minPrice, int maxPrice, int ticketSold, int favoriteCount, bool hasSeatMap
});




}
/// @nodoc
class _$EventSummaryCopyWithImpl<$Res>
    implements $EventSummaryCopyWith<$Res> {
  _$EventSummaryCopyWithImpl(this._self, this._then);

  final EventSummary _self;
  final $Res Function(EventSummary) _then;

/// Create a copy of EventSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? coverImageUrl = null,Object? startAt = null,Object? venueName = null,Object? provinceCode = null,Object? categoryNames = null,Object? minPrice = null,Object? maxPrice = null,Object? ticketSold = null,Object? favoriteCount = null,Object? hasSeatMap = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,coverImageUrl: null == coverImageUrl ? _self.coverImageUrl : coverImageUrl // ignore: cast_nullable_to_non_nullable
as String,startAt: null == startAt ? _self.startAt : startAt // ignore: cast_nullable_to_non_nullable
as DateTime,venueName: null == venueName ? _self.venueName : venueName // ignore: cast_nullable_to_non_nullable
as String,provinceCode: null == provinceCode ? _self.provinceCode : provinceCode // ignore: cast_nullable_to_non_nullable
as String,categoryNames: null == categoryNames ? _self.categoryNames : categoryNames // ignore: cast_nullable_to_non_nullable
as List<String>,minPrice: null == minPrice ? _self.minPrice : minPrice // ignore: cast_nullable_to_non_nullable
as int,maxPrice: null == maxPrice ? _self.maxPrice : maxPrice // ignore: cast_nullable_to_non_nullable
as int,ticketSold: null == ticketSold ? _self.ticketSold : ticketSold // ignore: cast_nullable_to_non_nullable
as int,favoriteCount: null == favoriteCount ? _self.favoriteCount : favoriteCount // ignore: cast_nullable_to_non_nullable
as int,hasSeatMap: null == hasSeatMap ? _self.hasSeatMap : hasSeatMap // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [EventSummary].
extension EventSummaryPatterns on EventSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventSummary value)  $default,){
final _that = this;
switch (_that) {
case _EventSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventSummary value)?  $default,){
final _that = this;
switch (_that) {
case _EventSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String coverImageUrl,  DateTime startAt,  String venueName,  String provinceCode,  List<String> categoryNames,  int minPrice,  int maxPrice,  int ticketSold,  int favoriteCount,  bool hasSeatMap)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventSummary() when $default != null:
return $default(_that.id,_that.title,_that.coverImageUrl,_that.startAt,_that.venueName,_that.provinceCode,_that.categoryNames,_that.minPrice,_that.maxPrice,_that.ticketSold,_that.favoriteCount,_that.hasSeatMap);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String coverImageUrl,  DateTime startAt,  String venueName,  String provinceCode,  List<String> categoryNames,  int minPrice,  int maxPrice,  int ticketSold,  int favoriteCount,  bool hasSeatMap)  $default,) {final _that = this;
switch (_that) {
case _EventSummary():
return $default(_that.id,_that.title,_that.coverImageUrl,_that.startAt,_that.venueName,_that.provinceCode,_that.categoryNames,_that.minPrice,_that.maxPrice,_that.ticketSold,_that.favoriteCount,_that.hasSeatMap);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String coverImageUrl,  DateTime startAt,  String venueName,  String provinceCode,  List<String> categoryNames,  int minPrice,  int maxPrice,  int ticketSold,  int favoriteCount,  bool hasSeatMap)?  $default,) {final _that = this;
switch (_that) {
case _EventSummary() when $default != null:
return $default(_that.id,_that.title,_that.coverImageUrl,_that.startAt,_that.venueName,_that.provinceCode,_that.categoryNames,_that.minPrice,_that.maxPrice,_that.ticketSold,_that.favoriteCount,_that.hasSeatMap);case _:
  return null;

}
}

}

/// @nodoc


class _EventSummary implements EventSummary {
  const _EventSummary({required this.id, required this.title, required this.coverImageUrl, required this.startAt, required this.venueName, required this.provinceCode, required final  List<String> categoryNames, required this.minPrice, required this.maxPrice, required this.ticketSold, required this.favoriteCount, required this.hasSeatMap}): _categoryNames = categoryNames;
  

@override final  String id;
@override final  String title;
@override final  String coverImageUrl;
@override final  DateTime startAt;
@override final  String venueName;
@override final  String provinceCode;
 final  List<String> _categoryNames;
@override List<String> get categoryNames {
  if (_categoryNames is EqualUnmodifiableListView) return _categoryNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categoryNames);
}

@override final  int minPrice;
@override final  int maxPrice;
@override final  int ticketSold;
@override final  int favoriteCount;
@override final  bool hasSeatMap;

/// Create a copy of EventSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventSummaryCopyWith<_EventSummary> get copyWith => __$EventSummaryCopyWithImpl<_EventSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.coverImageUrl, coverImageUrl) || other.coverImageUrl == coverImageUrl)&&(identical(other.startAt, startAt) || other.startAt == startAt)&&(identical(other.venueName, venueName) || other.venueName == venueName)&&(identical(other.provinceCode, provinceCode) || other.provinceCode == provinceCode)&&const DeepCollectionEquality().equals(other._categoryNames, _categoryNames)&&(identical(other.minPrice, minPrice) || other.minPrice == minPrice)&&(identical(other.maxPrice, maxPrice) || other.maxPrice == maxPrice)&&(identical(other.ticketSold, ticketSold) || other.ticketSold == ticketSold)&&(identical(other.favoriteCount, favoriteCount) || other.favoriteCount == favoriteCount)&&(identical(other.hasSeatMap, hasSeatMap) || other.hasSeatMap == hasSeatMap));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,coverImageUrl,startAt,venueName,provinceCode,const DeepCollectionEquality().hash(_categoryNames),minPrice,maxPrice,ticketSold,favoriteCount,hasSeatMap);

@override
String toString() {
  return 'EventSummary(id: $id, title: $title, coverImageUrl: $coverImageUrl, startAt: $startAt, venueName: $venueName, provinceCode: $provinceCode, categoryNames: $categoryNames, minPrice: $minPrice, maxPrice: $maxPrice, ticketSold: $ticketSold, favoriteCount: $favoriteCount, hasSeatMap: $hasSeatMap)';
}


}

/// @nodoc
abstract mixin class _$EventSummaryCopyWith<$Res> implements $EventSummaryCopyWith<$Res> {
  factory _$EventSummaryCopyWith(_EventSummary value, $Res Function(_EventSummary) _then) = __$EventSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String coverImageUrl, DateTime startAt, String venueName, String provinceCode, List<String> categoryNames, int minPrice, int maxPrice, int ticketSold, int favoriteCount, bool hasSeatMap
});




}
/// @nodoc
class __$EventSummaryCopyWithImpl<$Res>
    implements _$EventSummaryCopyWith<$Res> {
  __$EventSummaryCopyWithImpl(this._self, this._then);

  final _EventSummary _self;
  final $Res Function(_EventSummary) _then;

/// Create a copy of EventSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? coverImageUrl = null,Object? startAt = null,Object? venueName = null,Object? provinceCode = null,Object? categoryNames = null,Object? minPrice = null,Object? maxPrice = null,Object? ticketSold = null,Object? favoriteCount = null,Object? hasSeatMap = null,}) {
  return _then(_EventSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,coverImageUrl: null == coverImageUrl ? _self.coverImageUrl : coverImageUrl // ignore: cast_nullable_to_non_nullable
as String,startAt: null == startAt ? _self.startAt : startAt // ignore: cast_nullable_to_non_nullable
as DateTime,venueName: null == venueName ? _self.venueName : venueName // ignore: cast_nullable_to_non_nullable
as String,provinceCode: null == provinceCode ? _self.provinceCode : provinceCode // ignore: cast_nullable_to_non_nullable
as String,categoryNames: null == categoryNames ? _self._categoryNames : categoryNames // ignore: cast_nullable_to_non_nullable
as List<String>,minPrice: null == minPrice ? _self.minPrice : minPrice // ignore: cast_nullable_to_non_nullable
as int,maxPrice: null == maxPrice ? _self.maxPrice : maxPrice // ignore: cast_nullable_to_non_nullable
as int,ticketSold: null == ticketSold ? _self.ticketSold : ticketSold // ignore: cast_nullable_to_non_nullable
as int,favoriteCount: null == favoriteCount ? _self.favoriteCount : favoriteCount // ignore: cast_nullable_to_non_nullable
as int,hasSeatMap: null == hasSeatMap ? _self.hasSeatMap : hasSeatMap // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
