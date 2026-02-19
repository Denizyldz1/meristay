import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../hotels/domain/entities/hotel.dart';
import '../providers/reservation_provider.dart';

class ReservationScreen extends ConsumerStatefulWidget {
  const ReservationScreen({super.key, required this.hotel});

  final Hotel hotel;

  @override
  ConsumerState<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends ConsumerState<ReservationScreen> {
  DateTime? _checkIn;
  DateTime? _checkOut;
  int _guestCount = 1;

  int get _nightCount {
    if (_checkIn == null || _checkOut == null) return 0;
    return _checkOut!.difference(_checkIn!).inDays;
  }

  double get _totalPrice => widget.hotel.pricePerNight * _nightCount * _guestCount;

  Future<void> _pickDate({required bool isCheckIn}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn ? now : (_checkIn ?? now).add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          _checkIn = picked;
          // Check-in değişince check-out'u sıfırla
          if (_checkOut != null && _checkOut!.isBefore(picked)) {
            _checkOut = null;
          }
        } else {
          _checkOut = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reservationProvider);

    ref.listen<ReservationState>(reservationProvider, (previous, next) {
      if (next is ReservationSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Rezervasyon başarıyla oluşturuldu!'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/hotels');
      } else if (next is ReservationError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Rezervasyon')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Otel bilgisi
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const Icon(Icons.hotel, color: Colors.blue),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.hotel.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.hotel.city,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Tarih seçimi
            Row(
              children: [
                Expanded(
                  child: _DateCard(
                    label: 'Giriş',
                    date: _checkIn,
                    onTap: () => _pickDate(isCheckIn: true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DateCard(
                    label: 'Çıkış',
                    date: _checkOut,
                    onTap: () => _pickDate(isCheckIn: false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Misafir sayısı
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Misafir Sayısı', style: TextStyle(fontSize: 16)),
                Row(
                  children: [
                    IconButton(
                      onPressed: _guestCount > 1
                          ? () => setState(() => _guestCount--)
                          : null,
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Text(
                      '$_guestCount',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: _guestCount < 10
                          ? () => setState(() => _guestCount++)
                          : null,
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),

            // Fiyat özeti
            if (_nightCount > 0)
              Card(
                color: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('$_nightCount gece x $_guestCount misafir'),
                          Text('\$${_totalPrice.toStringAsFixed(0)}'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),

            // Rezervasyon butonu
            if (state is ReservationLoading) const Center(child: CircularProgressIndicator()) else ElevatedButton(
                    onPressed: _checkIn != null && _checkOut != null
                        ? () => ref
                            .read(reservationProvider.notifier)
                            .createReservation(
                              hotel: widget.hotel,
                              checkIn: _checkIn!,
                              checkOut: _checkOut!,
                              guestCount: _guestCount,
                            )
                        : null,
                    child: const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('Rezervasyonu Onayla'),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class _DateCard extends StatelessWidget {
  const _DateCard({
    required this.label,
    required this.date,
    required this.onTap,
  });

  final String label;
  final DateTime? date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 4),
              Text(
                date != null
                    ? '${date!.day}/${date!.month}/${date!.year}'
                    : 'Seç',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: date != null ? Colors.black : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}