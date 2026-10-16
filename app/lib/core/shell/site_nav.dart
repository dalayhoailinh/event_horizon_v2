import 'package:flutter/material.dart';

import '../router/route_names.dart';

class NavLink {
  final String label;
  final String? route;

  /// Icon for the mobile-app bottom tabs and the drawer. Footer links don't
  /// need one.
  final IconData? icon;
  final IconData? selectedIcon;
  const NavLink({
    required this.label,
    this.route,
    this.icon,
    this.selectedIcon,
  });
}

class NavGroup {
  final String title;
  final List<NavLink> links;
  const NavGroup({required this.title, required this.links});
}

const kSiteNav = [
  NavLink(
    label: 'Trang chủ',
    route: RouteNames.home,
    icon: Icons.home_outlined,
    selectedIcon: Icons.home,
  ),
  NavLink(
    label: 'Khám phá',
    route: RouteNames.events,
    icon: Icons.explore_outlined,
    selectedIcon: Icons.explore,
  ),
  NavLink(
    label: 'Vé của tôi',
    route: RouteNames.myTickets,
    icon: Icons.confirmation_num_outlined,
    selectedIcon: Icons.confirmation_num,
  ),
];

/// Index of the top-level section a location belongs to, or null for pages
/// outside the main nav (login, payment...). `/events/abc` belongs to
/// "Khám phá", `/my-tickets/xyz` to "Vé của tôi".
int? siteNavIndexOf(String location) {
  for (var i = kSiteNav.length - 1; i >= 0; i--) {
    final route = kSiteNav[i].route;
    if (route == null) continue;
    if (route == RouteNames.home) {
      if (location == RouteNames.home) return i;
      continue;
    }
    if (location == route || location.startsWith('$route/')) return i;
  }
  return null;
}

/// True only on the section roots themselves — those get the bottom tabs in
/// the mobile app; deeper pages get a back arrow instead.
bool isSiteNavRoot(String location) =>
    kSiteNav.any((link) => link.route == location);

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
