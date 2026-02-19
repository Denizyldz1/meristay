import 'package:dio/dio.dart';
import 'package:meristay/features/hotels/domain/entities/hotel.dart';
import '../../domain/repositories/favorites_repository.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  FavoritesRepositoryImpl(this._dio);

  final Dio _dio;

  final List<Hotel> _favorites = [];

  @override
  Future<List<Hotel>> getFavorites() async {
    return List.unmodifiable(_favorites);
  }
  // List.unmodifiable() listeyi sadece buradan ekleme çıkarma yapabilmesi için korur dışarıdan add vs yapılamaz.

  @override
  Future<void> addToFavorites(Hotel hotel) async {
    if (!await isFavorite(hotel.id)) {
      _favorites.add(hotel);
    }
  }

  @override
  Future<void> removeFromFavorites(Hotel hotel) async {
    _favorites.removeWhere((h) => h.id == hotel.id);
  }

  @override
  Future<bool> isFavorite(int hotelId) async {
    return _favorites.any((h) => h.id == hotelId);
  }
}
