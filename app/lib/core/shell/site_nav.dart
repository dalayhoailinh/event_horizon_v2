import '../router/route_names.dart';

class NavLink {
  final String label;
  final String route;
  const NavLink({required this.label, required this.route});
}

const kSiteNav = [
  NavLink(label: 'Trang chủ', route: RouteNames.home),
  NavLink(label: 'Sự kiện', route: RouteNames.events),
];
