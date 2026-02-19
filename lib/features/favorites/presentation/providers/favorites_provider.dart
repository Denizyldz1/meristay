import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meristay/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:meristay/features/favorites/domain/repositories/favorites_repository.dart';
import '../../../../core/network/dio_provider.dart';
import '../../../hotels/domain/entities/hotel.dart';

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  return FavoritesRepositoryImpl(ref.read(dioProvider));
});

sealed class FavoritesState {}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<Hotel> favorites;
  FavoritesLoaded(this.favorites);
}

class FavoritesError extends FavoritesState {
  final String message;
  FavoritesError(this.message);
}

class FavoritesNotifier extends Notifier<FavoritesState> {
  @override
  FavoritesState build() {
    fetchFavorites();
    return FavoritesInitial();
  }

  Future<void> fetchFavorites() async {
    state = FavoritesLoading();
    try {
      final favorites = await ref
          .read(favoritesRepositoryProvider)
          .getFavorites();
      state = FavoritesLoaded(favorites);
    } catch (e) {
      state = FavoritesError(e.toString());
    }
  }

  Future<void> addFavorite(Hotel hotel) async {
    try {
      await ref.read(favoritesRepositoryProvider).addToFavorites(hotel);
      await fetchFavorites();
    } catch (e) {
      state = FavoritesError(e.toString());
    }
  }

  Future<void> removerFavorite(Hotel hotel) async {
    try {
      await ref.read(favoritesRepositoryProvider).removeFromFavorites(hotel);
      await fetchFavorites();
    } catch (e) {
      state = FavoritesError(e.toString());
    }
  }
}

final favoritesProvider = NotifierProvider<FavoritesNotifier, FavoritesState>(
  FavoritesNotifier.new,
);
