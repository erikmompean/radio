import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio/providers/models/main_list_page_provider.dart';
import 'package:radio/providers/radio_manager_provider.dart';
import 'package:radio/providers/radio_storage_provider.dart';
import 'package:radio/routes/routes.dart';
import 'package:radio/services/api_radio_browser.dart';
import 'package:radio/services/audio_player_service.dart';
import 'package:radio/services/shared_preferences_service.dart';
import 'package:radio/utils/app_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RadioManagerProvider>(
            create: (_) => RadioManagerProvider(
                AudioPlayerService(), StorageServiceSingleton.instance)),
        ChangeNotifierProvider<MainListPageProvider>(
            create: (_) => MainListPageProvider(ApiRadioBrowser.instance)),
        ChangeNotifierProvider(
            create: (_) =>
                RadioStorageProvider(StorageServiceSingleton.instance)),
      ],
      child: MaterialApp.router(
        title: 'Radio App',
        routerConfig: Routes.instance.router,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.transparent,
          inputDecorationTheme: const InputDecorationTheme(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary),
            ),
            hintStyle: TextStyle(color: Colors.white),
          ),
          textTheme: const TextTheme(
            bodySmall: TextStyle(color: Colors.white),
            bodyMedium: TextStyle(color: Colors.white),
            bodyLarge: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
