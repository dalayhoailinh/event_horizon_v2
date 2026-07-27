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
