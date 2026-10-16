import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../router/route_names.dart';
import '../theme/app_radius.dart';

/// Search box in the header: Enter opens "Khám phá" filtered by the text.
class HeaderSearchField extends StatefulWidget {
  static const double width = 240;

  /// Called after navigating (the drawer uses it to close itself).
  final VoidCallback? onSearched;

  const HeaderSearchField({super.key, this.onSearched});

  @override
  State<HeaderSearchField> createState() => _HeaderSearchFieldState();
}

class _HeaderSearchFieldState extends State<HeaderSearchField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit(String value) {
    final query = value.trim();
    if (query.isEmpty) return;
    _controller.clear();
    final router = GoRouter.of(context);
    widget.onSearched?.call();
    router.go(RouteNames.eventsSearchPath(query));
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(AppRadius.sm);
    return SizedBox(
      width: HeaderSearchField.width,
      height: 40,
      child: TextField(
        controller: _controller,
        onSubmitted: _submit,
        textInputAction: TextInputAction.search,
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
          hintText: 'Tìm kiếm...',
          isDense: true,
          filled: true,
          fillColor: scheme.surface,
          prefixIcon: const Icon(Icons.search, size: 20),
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: radius,
            borderSide: BorderSide(color: scheme.outline),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: radius,
            borderSide: BorderSide(color: scheme.primary, width: 1.5),
          ),
        ),
      ),
    );
  }
}
