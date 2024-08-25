
enum HomeScreenPages { mainList, favorites, search }

extension HomeScreenPagesExtension on HomeScreenPages {
  int get number {
    switch (this) {
      case HomeScreenPages.mainList:
        return 0;
      case HomeScreenPages.search:
        return 1;
      case HomeScreenPages.favorites:
        return 2;
    }
  }

  static HomeScreenPages fromNumber(int number) {
    switch (number) {
      case 0:
        return HomeScreenPages.mainList;
      case 1:
        return HomeScreenPages.search;
      case 2:
        return HomeScreenPages.favorites;
      default:
        throw Exception('Invalid index');
    }
  }
}
