import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/format/formatters.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/skeleton_box.dart';
import '../../domain/entities/event_summary.dart';

/// Full-width banner of featured events: auto-advances, arrows + dots, and a
/// "Đặt vé ngay" button that opens the event.
class HeroCarousel extends StatefulWidget {
  final List<EventSummary> events;
  final bool loading;

  const HeroCarousel({super.key, required this.events}) : loading = false;
  const HeroCarousel.skeleton({super.key}) : events = const [], loading = true;

  static double heightFor(WindowSize size) => switch (size) {
    WindowSize.compact => 220,
    WindowSize.medium => 300,
    WindowSize.expanded => 400,
  };

  @override
  State<HeroCarousel> createState() => _HeroCarouselState();
}

class _HeroCarouselState extends State<HeroCarousel> {
  static const _autoInterval = Duration(seconds: 6);
  static const _slide = Duration(milliseconds: 420);

  final _controller = PageController();
  Timer? _timer;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _restartTimer();
  }

  @override
  void didUpdateWidget(HeroCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.events != widget.events) {
      _index = 0;
      if (_controller.hasClients) _controller.jumpToPage(0);
      _restartTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _restartTimer() {
    _timer?.cancel();
    if (widget.events.length <= 1) return;
    _timer = Timer.periodic(_autoInterval, (_) => _goTo(_index + 1));
  }

  void _goTo(int index) {
    final total = widget.events.length;
    if (total <= 1 || !_controller.hasClients) return;
    _controller.animateToPage(
      (index % total + total) % total,
      duration: _slide,
      curve: Curves.easeOutCubic,
    );
  }

  void _manualGoTo(int index) {
    _goTo(index);
    _restartTimer(); // the user is looking: don't flip right after a click
  }

  @override
  Widget build(BuildContext context) {
    final height = HeroCarousel.heightFor(context.windowSize);
    if (widget.loading) {
      return SkeletonBox(height: height, radius: AppRadius.lg);
    }
    if (widget.events.isEmpty) return const SizedBox.shrink();

    final total = widget.events.length;
    final scheme = Theme.of(context).colorScheme;
    final showArrows = total > 1 && !context.windowSize.isCompact;

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: SizedBox(
        height: height,
        child: Stack(
          children: [
            PageView(
              controller: _controller,
              onPageChanged: (i) => setState(() => _index = i),
              children: [
                for (final event in widget.events) _Slide(event: event),
              ],
            ),
            if (showArrows) ...[
              Positioned(
                left: AppSpacing.md,
                top: 0,
                bottom: 0,
                child: _Arrow(
                  icon: Icons.chevron_left,
                  onTap: () => _manualGoTo(_index - 1),
                ),
              ),
              Positioned(
                right: AppSpacing.md,
                top: 0,
                bottom: 0,
                child: _Arrow(
                  icon: Icons.chevron_right,
                  onTap: () => _manualGoTo(_index + 1),
                ),
              ),
            ],
            if (total > 1)
              Positioned(
                left: 0,
                right: 0,
                bottom: AppSpacing.md,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 0; i < total; i++)
                      GestureDetector(
                        onTap: () => _manualGoTo(i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 240),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: i == _index ? 16 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: i == _index
                                ? scheme.primary
                                : Colors.white.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(AppRadius.full),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  final EventSummary event;
  const _Slide({required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final compact = context.windowSize.isCompact;
    final venue = event.venueName.trim();
    final subtitle =
        '${formatEventDate(event.startAt)} • ${formatTimeOfDay(event.startAt)}'
        '${venue.isEmpty ? '' : '  |  $venue'}';

    return Stack(
      fit: StackFit.expand,
      children: [
        AppNetworkImage(url: event.coverImageUrl),
        // Darken the lower half so white text reads on any photo.
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x00000000), Color(0x99000000)],
              stops: [0.35, 1],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.xxl,
            AppSpacing.lg,
            AppSpacing.xxl,
            AppSpacing.xl + AppSpacing.sm,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                event.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style:
                    (compact
                            ? theme.textTheme.titleLarge
                            : theme.textTheme.headlineMedium)
                        ?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
              ),
              AppSpacing.vXs,
              Text(
                subtitle,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
              if (!compact) ...[
                AppSpacing.vMd,
                FilledButton(
                  onPressed: () =>
                      context.go(RouteNames.eventDetailPath(event.id)),
                  child: const Text('Đặt vé ngay'),
                ),
              ],
            ],
          ),
        ),
        // On a phone the whole slide is the button.
        if (compact)
          Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: () => context.go(RouteNames.eventDetailPath(event.id)),
            ),
          ),
      ],
    );
  }
}

class _Arrow extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _Arrow({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.black.withValues(alpha: 0.35),
        shape: const CircleBorder(),
        child: IconButton(
          icon: Icon(icon, color: Colors.white),
          onPressed: onTap,
        ),
      ),
    );
  }
}
