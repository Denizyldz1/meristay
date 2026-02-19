import 'package:dio/dio.dart';
import 'package:meristay/features/hotels/domain/entities/hotel.dart';
import 'package:meristay/features/hotels/domain/repositories/hotel_repository.dart';

class HotelRepositoryImpl implements HotelRepository {
  HotelRepositoryImpl(this._dio);

  final Dio _dio;
  @override
  Future<List<Hotel>> getHotels() async {
    // Gerçek API gelene kadar mock data
    // API entegrasyonu yaparken bu kısmı _dio.get(...) ile değiştirip gerçek veriyi parse edeceğiz.
    await Future.delayed(const Duration(seconds: 1)); // network simülasyonu
    return [
      const Hotel(
        id: 1,
        name: 'Merit Royal Hotel',
        city: 'Girne',
        rating: 4.8,
        pricePerNight: 150.0,
        imageUrl: 'https://picsum.photos/400/200',
        isAvailable: true,
      ),
      const Hotel(
        id: 2,
        name: 'Merit Crystal Cove',
        city: 'Gazimağusa',
        rating: 4.6,
        pricePerNight: 120.0,
        imageUrl: 'https://picsum.photos/400/201',
        isAvailable: true,
      ),
    ];
  }

  @override
  Future<Hotel> getHotelById(int id) async {
    final hotels = await getHotels();
    return hotels.firstWhere((h) => h.id == id);
  }
  
}

// HotelRepositoryImpl, HotelRepository arayüzünü implement eder ve mock data sağlar. Gerçek API entegrasyonu yaparken sadece bu sınıfı güncellememiz yeterli olacaktır.