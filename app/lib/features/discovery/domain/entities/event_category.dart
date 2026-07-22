import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_category.freezed.dart';

@freezed
abstract class EventCategory with _$EventCategory {
  const factory EventCategory({required String id, required String name}) =
      _EventCategory;
}
