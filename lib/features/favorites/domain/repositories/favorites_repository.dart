import '../../../hotels/domain/entities/hotel.dart';

abstract class FavoritesRepository {
  Future<List<Hotel>> getFavorites();
  Future<void> addToFavorites(Hotel hotel);
  Future<void> removeFromFavorites(Hotel hotel);
  Future<bool> isFavorite(int hotelId);
}
