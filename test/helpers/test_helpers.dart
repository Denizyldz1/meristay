import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meristay/features/auth/domain/repositories/auth_repository.dart';
import 'package:meristay/features/hotels/domain/repositories/hotel_repository.dart';
import 'package:meristay/features/reservations/domain/repositories/reservation_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockHotelRepository extends Mock implements HotelRepository {}
class  MockAuthRepository extends Mock implements AuthRepository {}
class MockReservationRepository extends Mock implements ReservationRepository {}

// mocktail paketi bu sınıfa özel güçler veriyor. when(() => mockRepository.getHotels()).thenAnswer(...) diyerek "bu metod çağrılırsa şunu döndür" diyebiliyoruz. Gerçek API çağrısı yok, internet bağlantısı yok, hızlı çalışıyor.
// Abstract repository yazmamızın faydası burada ortaya çıkıyor — MockHotelRepository da HotelRepositoryImpl de aynı sözleşmeyi uyguluyor, Notifier ikisinin farkını bilmiyor.



// Test container oluşturucu
ProviderContainer makeContainer({List<Override> overrides = const []}) {
  final container = ProviderContainer(overrides: overrides);
  addTearDown(container.dispose); // test bitince temizle
  return container;
}


// ProviderContainer Riverpod'un test ortamı. Normalde ProviderScope widget'ı bu işi yapıyor ama testlerde widget tree yok, bu yüzden ProviderContainer kullanıyoruz.
// overrides — gerçek provider'ın yerine mock'u geçiriyoruz. hotelRepositoryProvider.overrideWithValue(mockRepository) diyince Notifier gerçek implementasyon yerine mock'u kullanıyor.
// addTearDown(container.dispose) — her test bittikten sonra container'ı temizliyor, testler birbirini etkilemiyor.