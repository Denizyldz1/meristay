import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meristay/features/favorites/presentation/providers/favorites_provider.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/providers/language_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../hotels/presentation/widgets/hotel_card.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('favorites')),
        actions: [
          // Dil butonu
          Consumer(
            builder: (context, ref, _) {
              final locale = ref.watch(languageProvider);
              return TextButton(
                onPressed: () {
                  ref
                      .read(languageProvider.notifier)
                      .state = locale.languageCode == 'tr'
                      ? const Locale('en')
                      : const Locale('tr');
                },
                child: Text(
                  locale.languageCode == 'tr' ? 'EN' : 'TR',
                  style: const TextStyle(color: Colors.black),
                ),
              );
            },
          ),
          // Logout butonu
          Consumer(
            builder: (context, ref, _) {
              return IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => ref.read(authProvider.notifier).logout(),
              );
            },
          ),
        ],
      ),
      body: switch (state) {
        FavoritesInitial() ||
        FavoritesLoading() => const Center(child: CircularProgressIndicator()),
        FavoritesError(:final message) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(message),
              ElevatedButton(
                onPressed: () =>
                    ref.read(favoritesProvider.notifier).fetchFavorites(),
                child: const Text('Tekrar Dene'),
              ),
            ],
          ),
        ),
        FavoritesLoaded(:final favorites) => ListView.builder(
          itemCount: favorites.length,
          itemBuilder: (_, index) => HotelCard(hotel: favorites[index]),
        ),
      },
    );
  }
}
