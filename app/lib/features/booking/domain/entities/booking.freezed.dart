// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BookingLineItem {

 String get ticketTypeId; String get name; int get price; int get quantity;
/// Create a copy of BookingLineItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingLineItemCopyWith<BookingLineItem> get copyWith => _$BookingLineItemCopyWithImpl<BookingLineItem>(this as BookingLineItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingLineItem&&(identical(other.ticketTypeId, ticketTypeId) || other.ticketTypeId == ticketTypeId)&&(identical(other.name, name) || other.name == name)&&(identical(other.price, price) || other.price == price)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}


@override
int get hashCode => Object.hash(runtimeType,ticketTypeId,name,price,quantity);

@override
String toString() {
  return 'BookingLineItem(ticketTypeId: $ticketTypeId, name: $name, price: $price, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class $BookingLineItemCopyWith<$Res>  {
  factory $BookingLineItemCopyWith(BookingLineItem value, $Res Function(BookingLineItem) _then) = _$BookingLineItemCopyWithImpl;
@useResult
$Res call({
 String ticketTypeId, String name, int price, int quantity
});




}
/// @nodoc
class _$BookingLineItemCopyWithImpl<$Res>
    implements $BookingLineItemCopyWith<$Res> {
  _$BookingLineItemCopyWithImpl(this._self, this._then);

  final BookingLineItem _self;
  final $Res Function(BookingLineItem) _then;

/// Create a copy of BookingLineItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ticketTypeId = null,Object? name = null,Object? price = null,Object? quantity = null,}) {
  return _then(_self.copyWith(
ticketTypeId: null == ticketTypeId ? _self.ticketTypeId : ticketTypeId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BookingLineItem].
extension BookingLineItemPatterns on BookingLineItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingLineItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingLineItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingLineItem value)  $default,){
final _that = this;
switch (_that) {
case _BookingLineItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingLineItem value)?  $default,){
final _that = this;
switch (_that) {
case _BookingLineItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String ticketTypeId,  String name,  int price,  int quantity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingLineItem() when $default != null:
return $default(_that.ticketTypeId,_that.name,_that.price,_that.quantity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String ticketTypeId,  String name,  int price,  int quantity)  $default,) {final _that = this;
switch (_that) {
case _BookingLineItem():
return $default(_that.ticketTypeId,_that.name,_that.price,_that.quantity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String ticketTypeId,  String name,  int price,  int quantity)?  $default,) {final _that = this;
switch (_that) {
case _BookingLineItem() when $default != null:
return $default(_that.ticketTypeId,_that.name,_that.price,_that.quantity);case _:
  return null;

}
}

}

/// @nodoc


class _BookingLineItem implements BookingLineItem {
  const _BookingLineItem({required this.ticketTypeId, required this.name, required this.price, required this.quantity});
  

@override final  String ticketTypeId;
@override final  String name;
@override final  int price;
@override final  int quantity;

/// Create a copy of BookingLineItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingLineItemCopyWith<_BookingLineItem> get copyWith => __$BookingLineItemCopyWithImpl<_BookingLineItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingLineItem&&(identical(other.ticketTypeId, ticketTypeId) || other.ticketTypeId == ticketTypeId)&&(identical(other.name, name) || other.name == name)&&(identical(other.price, price) || other.price == price)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}


@override
int get hashCode => Object.hash(runtimeType,ticketTypeId,name,price,quantity);

@override
String toString() {
  return 'BookingLineItem(ticketTypeId: $ticketTypeId, name: $name, price: $price, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class _$BookingLineItemCopyWith<$Res> implements $BookingLineItemCopyWith<$Res> {
  factory _$BookingLineItemCopyWith(_BookingLineItem value, $Res Function(_BookingLineItem) _then) = __$BookingLineItemCopyWithImpl;
@override @useResult
$Res call({
 String ticketTypeId, String name, int price, int quantity
});




}
/// @nodoc
class __$BookingLineItemCopyWithImpl<$Res>
    implements _$BookingLineItemCopyWith<$Res> {
  __$BookingLineItemCopyWithImpl(this._self, this._then);

  final _BookingLineItem _self;
  final $Res Function(_BookingLineItem) _then;

/// Create a copy of BookingLineItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ticketTypeId = null,Object? name = null,Object? price = null,Object? quantity = null,}) {
  return _then(_BookingLineItem(
ticketTypeId: null == ticketTypeId ? _self.ticketTypeId : ticketTypeId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$BookingTicket {

 String get qrData; String get qrSignature;
/// Create a copy of BookingTicket
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingTicketCopyWith<BookingTicket> get copyWith => _$BookingTicketCopyWithImpl<BookingTicket>(this as BookingTicket, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingTicket&&(identical(other.qrData, qrData) || other.qrData == qrData)&&(identical(other.qrSignature, qrSignature) || other.qrSignature == qrSignature));
}


@override
int get hashCode => Object.hash(runtimeType,qrData,qrSignature);

@override
String toString() {
  return 'BookingTicket(qrData: $qrData, qrSignature: $qrSignature)';
}


}

/// @nodoc
abstract mixin class $BookingTicketCopyWith<$Res>  {
  factory $BookingTicketCopyWith(BookingTicket value, $Res Function(BookingTicket) _then) = _$BookingTicketCopyWithImpl;
@useResult
$Res call({
 String qrData, String qrSignature
});




}
/// @nodoc
class _$BookingTicketCopyWithImpl<$Res>
    implements $BookingTicketCopyWith<$Res> {
  _$BookingTicketCopyWithImpl(this._self, this._then);

  final BookingTicket _self;
  final $Res Function(BookingTicket) _then;

/// Create a copy of BookingTicket
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? qrData = null,Object? qrSignature = null,}) {
  return _then(_self.copyWith(
qrData: null == qrData ? _self.qrData : qrData // ignore: cast_nullable_to_non_nullable
as String,qrSignature: null == qrSignature ? _self.qrSignature : qrSignature // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BookingTicket].
extension BookingTicketPatterns on BookingTicket {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingTicket value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingTicket() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingTicket value)  $default,){
final _that = this;
switch (_that) {
case _BookingTicket():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingTicket value)?  $default,){
final _that = this;
switch (_that) {
case _BookingTicket() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String qrData,  String qrSignature)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingTicket() when $default != null:
return $default(_that.qrData,_that.qrSignature);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String qrData,  String qrSignature)  $default,) {final _that = this;
switch (_that) {
case _BookingTicket():
return $default(_that.qrData,_that.qrSignature);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String qrData,  String qrSignature)?  $default,) {final _that = this;
switch (_that) {
case _BookingTicket() when $default != null:
return $default(_that.qrData,_that.qrSignature);case _:
  return null;

}
}

}

/// @nodoc


class _BookingTicket implements BookingTicket {
  const _BookingTicket({required this.qrData, required this.qrSignature});
  

@override final  String qrData;
@override final  String qrSignature;

/// Create a copy of BookingTicket
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingTicketCopyWith<_BookingTicket> get copyWith => __$BookingTicketCopyWithImpl<_BookingTicket>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingTicket&&(identical(other.qrData, qrData) || other.qrData == qrData)&&(identical(other.qrSignature, qrSignature) || other.qrSignature == qrSignature));
}


@override
int get hashCode => Object.hash(runtimeType,qrData,qrSignature);

@override
String toString() {
  return 'BookingTicket(qrData: $qrData, qrSignature: $qrSignature)';
}


}

/// @nodoc
abstract mixin class _$BookingTicketCopyWith<$Res> implements $BookingTicketCopyWith<$Res> {
  factory _$BookingTicketCopyWith(_BookingTicket value, $Res Function(_BookingTicket) _then) = __$BookingTicketCopyWithImpl;
@override @useResult
$Res call({
 String qrData, String qrSignature
});




}
/// @nodoc
class __$BookingTicketCopyWithImpl<$Res>
    implements _$BookingTicketCopyWith<$Res> {
  __$BookingTicketCopyWithImpl(this._self, this._then);

  final _BookingTicket _self;
  final $Res Function(_BookingTicket) _then;

/// Create a copy of BookingTicket
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? qrData = null,Object? qrSignature = null,}) {
  return _then(_BookingTicket(
qrData: null == qrData ? _self.qrData : qrData // ignore: cast_nullable_to_non_nullable
as String,qrSignature: null == qrSignature ? _self.qrSignature : qrSignature // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$Booking {

 String get id; String get eventId; String get eventTitle; String get eventCoverUrl; DateTime get eventStartAt; String get venueName; String get venueAddress; List<BookingLineItem> get lineItems; int get totalAmount; BookingStatus get status; DateTime get createdAt; BookingTicket? get ticket;
/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingCopyWith<Booking> get copyWith => _$BookingCopyWithImpl<Booking>(this as Booking, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Booking&&(identical(other.id, id) || other.id == id)&&(identical(other.eventId, eventId) || other.eventId == eventId)&&(identical(other.eventTitle, eventTitle) || other.eventTitle == eventTitle)&&(identical(other.eventCoverUrl, eventCoverUrl) || other.eventCoverUrl == eventCoverUrl)&&(identical(other.eventStartAt, eventStartAt) || other.eventStartAt == eventStartAt)&&(identical(other.venueName, venueName) || other.venueName == venueName)&&(identical(other.venueAddress, venueAddress) || other.venueAddress == venueAddress)&&const DeepCollectionEquality().equals(other.lineItems, lineItems)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.ticket, ticket) || other.ticket == ticket));
}


@override
int get hashCode => Object.hash(runtimeType,id,eventId,eventTitle,eventCoverUrl,eventStartAt,venueName,venueAddress,const DeepCollectionEquality().hash(lineItems),totalAmount,status,createdAt,ticket);

@override
String toString() {
  return 'Booking(id: $id, eventId: $eventId, eventTitle: $eventTitle, eventCoverUrl: $eventCoverUrl, eventStartAt: $eventStartAt, venueName: $venueName, venueAddress: $venueAddress, lineItems: $lineItems, totalAmount: $totalAmount, status: $status, createdAt: $createdAt, ticket: $ticket)';
}


}

/// @nodoc
abstract mixin class $BookingCopyWith<$Res>  {
  factory $BookingCopyWith(Booking value, $Res Function(Booking) _then) = _$BookingCopyWithImpl;
@useResult
$Res call({
 String id, String eventId, String eventTitle, String eventCoverUrl, DateTime eventStartAt, String venueName, String venueAddress, List<BookingLineItem> lineItems, int totalAmount, BookingStatus status, DateTime createdAt, BookingTicket? ticket
});


$BookingTicketCopyWith<$Res>? get ticket;

}
/// @nodoc
class _$BookingCopyWithImpl<$Res>
    implements $BookingCopyWith<$Res> {
  _$BookingCopyWithImpl(this._self, this._then);

  final Booking _self;
  final $Res Function(Booking) _then;

/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? eventId = null,Object? eventTitle = null,Object? eventCoverUrl = null,Object? eventStartAt = null,Object? venueName = null,Object? venueAddress = null,Object? lineItems = null,Object? totalAmount = null,Object? status = null,Object? createdAt = null,Object? ticket = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String,eventTitle: null == eventTitle ? _self.eventTitle : eventTitle // ignore: cast_nullable_to_non_nullable
as String,eventCoverUrl: null == eventCoverUrl ? _self.eventCoverUrl : eventCoverUrl // ignore: cast_nullable_to_non_nullable
as String,eventStartAt: null == eventStartAt ? _self.eventStartAt : eventStartAt // ignore: cast_nullable_to_non_nullable
as DateTime,venueName: null == venueName ? _self.venueName : venueName // ignore: cast_nullable_to_non_nullable
as String,venueAddress: null == venueAddress ? _self.venueAddress : venueAddress // ignore: cast_nullable_to_non_nullable
as String,lineItems: null == lineItems ? _self.lineItems : lineItems // ignore: cast_nullable_to_non_nullable
as List<BookingLineItem>,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BookingStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,ticket: freezed == ticket ? _self.ticket : ticket // ignore: cast_nullable_to_non_nullable
as BookingTicket?,
  ));
}
/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingTicketCopyWith<$Res>? get ticket {
    if (_self.ticket == null) {
    return null;
  }

  return $BookingTicketCopyWith<$Res>(_self.ticket!, (value) {
    return _then(_self.copyWith(ticket: value));
  });
}
}


/// Adds pattern-matching-related methods to [Booking].
extension BookingPatterns on Booking {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Booking value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Booking() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Booking value)  $default,){
final _that = this;
switch (_that) {
case _Booking():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Booking value)?  $default,){
final _that = this;
switch (_that) {
case _Booking() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String eventId,  String eventTitle,  String eventCoverUrl,  DateTime eventStartAt,  String venueName,  String venueAddress,  List<BookingLineItem> lineItems,  int totalAmount,  BookingStatus status,  DateTime createdAt,  BookingTicket? ticket)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Booking() when $default != null:
return $default(_that.id,_that.eventId,_that.eventTitle,_that.eventCoverUrl,_that.eventStartAt,_that.venueName,_that.venueAddress,_that.lineItems,_that.totalAmount,_that.status,_that.createdAt,_that.ticket);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String eventId,  String eventTitle,  String eventCoverUrl,  DateTime eventStartAt,  String venueName,  String venueAddress,  List<BookingLineItem> lineItems,  int totalAmount,  BookingStatus status,  DateTime createdAt,  BookingTicket? ticket)  $default,) {final _that = this;
switch (_that) {
case _Booking():
return $default(_that.id,_that.eventId,_that.eventTitle,_that.eventCoverUrl,_that.eventStartAt,_that.venueName,_that.venueAddress,_that.lineItems,_that.totalAmount,_that.status,_that.createdAt,_that.ticket);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String eventId,  String eventTitle,  String eventCoverUrl,  DateTime eventStartAt,  String venueName,  String venueAddress,  List<BookingLineItem> lineItems,  int totalAmount,  BookingStatus status,  DateTime createdAt,  BookingTicket? ticket)?  $default,) {final _that = this;
switch (_that) {
case _Booking() when $default != null:
return $default(_that.id,_that.eventId,_that.eventTitle,_that.eventCoverUrl,_that.eventStartAt,_that.venueName,_that.venueAddress,_that.lineItems,_that.totalAmount,_that.status,_that.createdAt,_that.ticket);case _:
  return null;

}
}

}

/// @nodoc


class _Booking extends Booking {
  const _Booking({required this.id, required this.eventId, required this.eventTitle, required this.eventCoverUrl, required this.eventStartAt, required this.venueName, required this.venueAddress, required final  List<BookingLineItem> lineItems, required this.totalAmount, required this.status, required this.createdAt, this.ticket}): _lineItems = lineItems,super._();
  

@override final  String id;
@override final  String eventId;
@override final  String eventTitle;
@override final  String eventCoverUrl;
@override final  DateTime eventStartAt;
@override final  String venueName;
@override final  String venueAddress;
 final  List<BookingLineItem> _lineItems;
@override List<BookingLineItem> get lineItems {
  if (_lineItems is EqualUnmodifiableListView) return _lineItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lineItems);
}

@override final  int totalAmount;
@override final  BookingStatus status;
@override final  DateTime createdAt;
@override final  BookingTicket? ticket;

/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingCopyWith<_Booking> get copyWith => __$BookingCopyWithImpl<_Booking>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Booking&&(identical(other.id, id) || other.id == id)&&(identical(other.eventId, eventId) || other.eventId == eventId)&&(identical(other.eventTitle, eventTitle) || other.eventTitle == eventTitle)&&(identical(other.eventCoverUrl, eventCoverUrl) || other.eventCoverUrl == eventCoverUrl)&&(identical(other.eventStartAt, eventStartAt) || other.eventStartAt == eventStartAt)&&(identical(other.venueName, venueName) || other.venueName == venueName)&&(identical(other.venueAddress, venueAddress) || other.venueAddress == venueAddress)&&const DeepCollectionEquality().equals(other._lineItems, _lineItems)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.ticket, ticket) || other.ticket == ticket));
}


@override
int get hashCode => Object.hash(runtimeType,id,eventId,eventTitle,eventCoverUrl,eventStartAt,venueName,venueAddress,const DeepCollectionEquality().hash(_lineItems),totalAmount,status,createdAt,ticket);

@override
String toString() {
  return 'Booking(id: $id, eventId: $eventId, eventTitle: $eventTitle, eventCoverUrl: $eventCoverUrl, eventStartAt: $eventStartAt, venueName: $venueName, venueAddress: $venueAddress, lineItems: $lineItems, totalAmount: $totalAmount, status: $status, createdAt: $createdAt, ticket: $ticket)';
}


}

/// @nodoc
abstract mixin class _$BookingCopyWith<$Res> implements $BookingCopyWith<$Res> {
  factory _$BookingCopyWith(_Booking value, $Res Function(_Booking) _then) = __$BookingCopyWithImpl;
@override @useResult
$Res call({
 String id, String eventId, String eventTitle, String eventCoverUrl, DateTime eventStartAt, String venueName, String venueAddress, List<BookingLineItem> lineItems, int totalAmount, BookingStatus status, DateTime createdAt, BookingTicket? ticket
});


@override $BookingTicketCopyWith<$Res>? get ticket;

}
/// @nodoc
class __$BookingCopyWithImpl<$Res>
    implements _$BookingCopyWith<$Res> {
  __$BookingCopyWithImpl(this._self, this._then);

  final _Booking _self;
  final $Res Function(_Booking) _then;

/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? eventId = null,Object? eventTitle = null,Object? eventCoverUrl = null,Object? eventStartAt = null,Object? venueName = null,Object? venueAddress = null,Object? lineItems = null,Object? totalAmount = null,Object? status = null,Object? createdAt = null,Object? ticket = freezed,}) {
  return _then(_Booking(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String,eventTitle: null == eventTitle ? _self.eventTitle : eventTitle // ignore: cast_nullable_to_non_nullable
as String,eventCoverUrl: null == eventCoverUrl ? _self.eventCoverUrl : eventCoverUrl // ignore: cast_nullable_to_non_nullable
as String,eventStartAt: null == eventStartAt ? _self.eventStartAt : eventStartAt // ignore: cast_nullable_to_non_nullable
as DateTime,venueName: null == venueName ? _self.venueName : venueName // ignore: cast_nullable_to_non_nullable
as String,venueAddress: null == venueAddress ? _self.venueAddress : venueAddress // ignore: cast_nullable_to_non_nullable
as String,lineItems: null == lineItems ? _self._lineItems : lineItems // ignore: cast_nullable_to_non_nullable
as List<BookingLineItem>,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BookingStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,ticket: freezed == ticket ? _self.ticket : ticket // ignore: cast_nullable_to_non_nullable
as BookingTicket?,
  ));
}

/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingTicketCopyWith<$Res>? get ticket {
    if (_self.ticket == null) {
    return null;
  }

  return $BookingTicketCopyWith<$Res>(_self.ticket!, (value) {
    return _then(_self.copyWith(ticket: value));
  });
}
}

// dart format on
