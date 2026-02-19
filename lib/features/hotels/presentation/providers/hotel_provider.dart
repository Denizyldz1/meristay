import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meristay/core/network/dio_provider.dart';
import '../../domain/entities/hotel.dart';
import '../../domain/repositories/hotel_repository.dart';
import '../../data/repositories/hotel_repository_impl.dart';

final hotelRepositoryProvider = Provider<HotelRepository>((ref) {
  return HotelRepositoryImpl(ref.read(dioProvider));
});

// HotelRepositoryImpl nesnesini Riverpod'a kayıt ediyor. Artık uygulamanın herhangi bir yerinde ref.read(hotelRepositoryProvider) dersen sana bu nesneyi verir.
// GetIt'teki getIt.registerSingleton<HotelRepository>(HotelRepositoryImpl()) ile aynı mantık. Sadece Riverpod bunu ref üzerinden yapıyor.


// State sınıfları
sealed class HotelState {}
class HotelInitial extends HotelState {}
class HotelLoading extends HotelState {}
class HotelLoaded extends HotelState {
  final List<Hotel> hotels;
  HotelLoaded(this.hotels);
}

// Ekranın olabileceği her durumu temsil ediyor. sealed keyword'ü sayesinde Dart bu sınıfların dışında başka bir alt sınıf olamaz diyor — bu da switch'te tüm durumları zorunlu kılıyor, hiçbir state'i atlayamazsın.
// Şu an ekran 4 durumda olabilir:

// HotelInitial → henüz hiçbir şey olmadı
// HotelLoading → veri çekiliyor
// HotelLoaded → veriler geldi, listesi var
// HotelError → bir şeyler ters gitti, mesajı var

class HotelError extends HotelState {
  final String message;
  HotelError(this.message);
}

// Notifier
class HotelNotifier extends Notifier<HotelState> {
  @override
  HotelState build() {
    fetchHotels(); // build'de otomatik başlat
    return HotelInitial();
  }

  Future<void> fetchHotels() async {
    state = HotelLoading();
    try {
      final hotels = await ref.read(hotelRepositoryProvider).getHotels();
      state = HotelLoaded(hotels);
    } catch (e) {
      state = HotelError(e.toString());
    }
  }
}

final hotelProvider = NotifierProvider<HotelNotifier, HotelState>(
  HotelNotifier.new,
);

// Senin eski ChangeNotifier ViewModel'inin Riverpod karşılığı bu. Farklar şunlar:
// notifyListeners() yok — state = yazınca Riverpod otomatik UI'ı güncelliyor.
// build() metodu başlangıç state'ini döndürüyor. HotelInitial dönüyor, ama hemen fetchHotels() çağırıyor. Yani ekran açılır açılmaz veri çekmeye başlıyor.
// ref.read(hotelRepositoryProvider) ile repository'e erişiyor. GetIt'teki getIt<HotelRepository>() ile aynı mantık.
// state = her atandığında, bu provider'ı izleyen tüm widget'lar otomatik yeniden build ediliyor.