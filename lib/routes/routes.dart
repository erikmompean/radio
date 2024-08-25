import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:radio/providers/models/countries_screen_provider.dart';
import 'package:radio/providers/models/home_screen_provider.dart';
import 'package:radio/providers/models/searcher_screen_provider.dart';
import 'package:radio/routes/route_names.dart';
import 'package:radio/screens/countries_screen.dart';
import 'package:radio/screens/detail_screen.dart';
import 'package:radio/screens/home_screen.dart';
import 'package:radio/screens/searcher_screen.dart';
import 'package:radio/services/api_radio_browser.dart';
import 'package:radio/utils/transparent_page.dart';

class Routes {
  static final instance = Routes._();

  Routes._();

  final router = GoRouter(
    routes: [
      GoRoute(
        path: RouteNames.home,
        builder: (context, state) => ChangeNotifierProvider(
          create: (context) => HomeScreenStateProvider(),
          child: const HomeScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.detail,
        pageBuilder: (context, state) {
          return TransparentPage(
            builder: (context) => const DetailScreen(),
          );
        },
      ),
      GoRoute(
        path: RouteNames.searcher,
        builder: (context, state) => ChangeNotifierProvider(
          create: (context) => SearcherScreenProvider(ApiRadioBrowser.instance,
              country: state.extra as String?),
          child: const SearcherScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.countries,
        builder: (context, state) => ChangeNotifierProvider(
          create: (context) => CountriesScreenProvider(
            ApiRadioBrowser.instance,
          ),
          child: const CountriesScreen(),
        ),
      ),
    ],
  );
}
