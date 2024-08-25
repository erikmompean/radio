import 'package:flutter/widgets.dart';
import 'package:radio/enum/home_screen_pages.dart';

class HomeScreenStateProvider extends ChangeNotifier {
  HomeScreenPages _currentScreen = HomeScreenPages.mainList;
  final PageController _pageController = PageController(initialPage: HomeScreenPages.mainList.index);

  HomeScreenPages get currentScreen => _currentScreen;
  PageController get pageController => _pageController;

  void onTabTapped(HomeScreenPages page) {
    _currentScreen = page;
    _pageController.animateToPage(
      page.index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    notifyListeners();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}