import 'package:meristay/features/hotels/domain/entities/hotel.dart';

abstract class HotelRepository {
  Future<List<Hotel>> getHotels();
  Future<Hotel> getHotelById(int id);
}


// Abstract olarak vermemizin sebebi burada mock data ile başlayıp, ileride gerçek API entegrasyonu yaparken sadece bu interface'i implement eden bir sınıf yazmamız yeterli olacak. 
// Böylece kodumuz daha esnek ve test edilebilir hale gelir.