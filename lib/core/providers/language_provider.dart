import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

final languageProvider = StateProvider<Locale>((ref) => const Locale('tr'));