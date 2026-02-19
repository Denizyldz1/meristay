import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meristay/features/auth/presentation/screens/login_screen.dart';
import 'package:meristay/features/hotels/domain/entities/hotel.dart';
import 'package:meristay/features/hotels/presentation/screens/hotel_detail_screen.dart';
import 'package:meristay/features/hotels/presentation/screens/hotel_list_screen.dart';
import 'package:meristay/features/reservations/presentation/screens/reservation_screen.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/favorites/presentation/screens/favorites_screen.dart';

// Global ChangeNotifier — token değişimini router'a bildirir
class _AuthNotifier extends ChangeNotifier {
  void notify() => notifyListeners();
}

final _authNotifier = _AuthNotifier();

// GoRouter bir kere oluşturulur
final appRouter = GoRouter(
  refreshListenable: _authNotifier,
  initialLocation: '/login',
  redirect: (context, state) {
    // Container'dan token oku
    final token = _currentToken;
    final isLoggedIn = token != null;
    final isLoginPage = state.matchedLocation == '/login';
    if (!isLoggedIn && !isLoginPage) return '/login';
    if (isLoggedIn && isLoginPage) return '/hotels';
    return null;
  },
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/hotels',
      builder: (context, state) => const HotelListScreen(),
      routes: [
        GoRoute(
          path: 'detail/:id',
          builder: (context, state) {
            final hotel = state.extra as Hotel;
            return HotelDetailScreen(hotel: hotel);
          },
        ),
        GoRoute(
          path: 'reservation/:id',
          builder: (context, state) {
            final hotel = state.extra as Hotel;
            return ReservationScreen(hotel: hotel);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/favorites',
      builder: (context, state) => const FavoritesScreen(),
    ),
  ],
);

String? _currentToken;

// Token değişimini izleyen provider
final routerProvider = Provider<GoRouter>((ref) {
  ref.listen<String?>(authTokenProvider, (previous, next) {
    _currentToken = next;
    _authNotifier.notify();
  });
  return appRouter;
});
