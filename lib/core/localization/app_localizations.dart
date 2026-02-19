import 'package:flutter/material.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const _localizedStrings = {
    'tr': {
      'hotels': 'Oteller',
      'reservation': 'Rezervasyon',
      'login': 'Giriş Yap',
      'logout': 'Çıkış Yap',
      'email': 'E-posta',
      'password': 'Şifre',
      'checkIn': 'Giriş',
      'checkOut': 'Çıkış',
      'guestCount': 'Misafir Sayısı',
      'confirm': 'Rezervasyonu Onayla',
      'available': 'Müsait',
      'unavailable': 'Dolu',
      'perNight': 'gece',
      'reservationSuccess': 'Rezervasyon başarıyla oluşturuldu!',
      'favorites': 'Favoriler',
    },
    'en': {
      'hotels': 'Hotels',
      'reservation': 'Reservation',
      'login': 'Login',
      'logout': 'Logout',
      'email': 'Email',
      'password': 'Password',
      'checkIn': 'Check In',
      'checkOut': 'Check Out',
      'guestCount': 'Guest Count',
      'confirm': 'Confirm Reservation',
      'available': 'Available',
      'unavailable': 'Full',
      'perNight': 'night',
      'reservationSuccess': 'Reservation created successfully!',
      'favorites': 'Favorites',
    },
  };

  String translate(String key) {
    return _localizedStrings[locale.languageCode]?[key] ?? key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['tr', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
