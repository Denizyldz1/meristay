import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meristay/features/hotels/presentation/providers/hotel_provider.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/providers/language_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../widgets/hotel_card.dart';

class HotelListScreen extends ConsumerWidget {
  const HotelListScreen({super.key});

  // ConsumerWidget — normal StatelessWidget'ın Riverpod versiyonu. Farkı build metodunda WidgetRef ref parametresi geliyor.
  // ref.watch(hotelProvider) — bu provider'ı izlemeye başlıyor. State her değiştiğinde bu widget otomatik rebuild oluyor. ref.read ile farkı şu: read sadece bir kere okur, watch sürekli izler.
  // switch (state) — sealed class olduğu için tüm durumları yazmak zorundayız. HotelInitial ve HotelLoading'de loading göster, HotelError'da hata mesajı, HotelLoaded'da liste.

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(hotelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('hotels')),
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
        HotelInitial() ||
        HotelLoading() => const Center(child: CircularProgressIndicator()),
        HotelError(:final message) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(message),
              ElevatedButton(
                onPressed: () => ref.read(hotelProvider.notifier).fetchHotels(),
                child: const Text('Tekrar Dene'),
              ),
            ],
          ),
        ),
        HotelLoaded(:final hotels) => ListView.builder(
          itemCount: hotels.length,
          itemBuilder: (_, index) => HotelCard(hotel: hotels[index]),
        ),
      },
    );
  }
}
