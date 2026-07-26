import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../responsive/breakpoints.dart';

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
      body: Scrollbar(
        controller: _scrollController,
        thumbVisibility: kIsWeb && !compact,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              title: const _HeaderPlaceholder(),
            ),
            for (final section in widget.sections) ...[
              SliverToBoxAdapter(child: section),
            ],
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [_FooterPlaceholder()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderPlaceholder extends StatelessWidget {
  const _HeaderPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      color: Colors.grey,
      alignment: Alignment.center,
      child: const Text('TODO HEADER'),
    );
  }
}

class _FooterPlaceholder extends StatelessWidget {
  const _FooterPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: double.infinity,
      color: Colors.grey,
      alignment: Alignment.center,
      child: const Text('TODO FOOTER'),
    );
  }
}
