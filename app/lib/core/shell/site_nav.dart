import 'package:flutter/material.dart';

import '../router/route_names.dart';

class NavLink {
  final String label;
  final String? route;
  const NavLink({required this.label, this.route});
}

class NavGroup {
  final String title;
  final List<NavLink> links;
  const NavGroup({required this.title, required this.links});
}

const kSiteNav = [
  NavLink(label: 'Trang chủ', route: RouteNames.home),
  NavLink(label: 'Khám phá', route: RouteNames.events),
  NavLink(label: 'Vé của tôi', route: RouteNames.myTickets),
];

const kFooterNav = <NavGroup>[
  NavGroup(
    title: 'Khám phá',
    links: [
      NavLink(label: 'Sự kiện', route: RouteNames.events),
      NavLink(label: 'Thể loại'),
      NavLink(label: 'Tìm kiếm'),
    ],
  ),
  NavGroup(
    title: 'Hỗ trợ',
    links: [
      NavLink(label: 'Trung tâm trợ giúp'),
      NavLink(label: 'Liên hệ'),
      NavLink(label: 'Câu hỏi thường gặp'),
    ],
  ),
  NavGroup(
    title: 'Pháp lý',
    links: [
      NavLink(label: 'Điều khoản'),
      NavLink(label: 'Bảo mật'),
      NavLink(label: 'Chính sách của chúng tôi'),
    ],
  ),
];

ButtonStyle linkButtonStyle(
  ColorScheme scheme, {
  bool active = false,
  TextStyle? base,
}) {
  return ButtonStyle(
    overlayColor: const WidgetStatePropertyAll(Colors.transparent),
    splashFactory: NoSplash.splashFactory,
    foregroundColor: WidgetStateProperty.resolveWith((states) {
      final highlighted =
          active ||
          states.contains(WidgetState.hovered) ||
          states.contains(WidgetState.focused);
      return highlighted ? scheme.primary : scheme.onSurfaceVariant;
    }),
    textStyle: WidgetStateProperty.resolveWith((states) {
      return (base ?? const TextStyle()).copyWith(
        fontWeight: active ? FontWeight.w600 : FontWeight.w400,
        decoration: states.contains(WidgetState.hovered)
            ? TextDecoration.underline
            : TextDecoration.none,
      );
    }),
  );
}
