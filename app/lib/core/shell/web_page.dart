import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../responsive/breakpoints.dart';
import 'app_footer.dart';
import 'app_header.dart';
import 'app_nav_drawer.dart';

class WebPage extends StatefulWidget {
  final List<Widget> sections;
  const WebPage({super.key, required this.sections});

  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final compact = context.windowSize.isCompact;
    return Scaffold(
      endDrawer: compact ? const AppNavDrawer() : null,
      body: Scrollbar(
        controller: _scrollController,
        thumbVisibility: kIsWeb && !compact,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              pinned: true,
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              title: const AppHeader(),
            ),
            for (final section in widget.sections) ...[
              SliverToBoxAdapter(child: section),
            ],
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [AppFooter()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
