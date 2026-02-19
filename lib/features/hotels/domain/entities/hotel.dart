class Hotel {
  final int id;
  final String name;
  final String city;
  final double rating;
  final double pricePerNight;
  final String imageUrl;
  final bool isAvailable;

  const Hotel({
    required this.id,
    required this.name,
    required this.city,
    required this.rating,
    required this.pricePerNight,
    required this.imageUrl,
    required this.isAvailable,
  });
}