import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:radio/enum/home_screen_pages.dart';
import 'package:radio/enum/radio_status.dart';
import 'package:radio/providers/models/explore_page_provider.dart';
import 'package:radio/providers/models/home_screen_provider.dart';
import 'package:radio/providers/models/main_list_page_provider.dart';
import 'package:radio/providers/radio_manager_provider.dart';
import 'package:radio/providers/radio_storage_provider.dart';
import 'package:radio/routes/route_names.dart';
import 'package:radio/screens/pages/explore_page.dart';
import 'package:radio/screens/pages/favorites_page.dart';
import 'package:radio/screens/pages/main_list_page.dart';
import 'package:radio/utils/app_colors.dart';
import 'package:radio/widgets/bottom_bar.dart';
import 'package:radio/widgets/current_radio_station.dart';
import 'package:radio/widgets/selectable_icon_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<RadioStorageProvider>(context, listen: false)
          .initialize();

      if (mounted) {
        await Provider.of<MainListPageProvider>(context, listen: false)
            .getTopVotedRadioStations('spain');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      // color: Color(0xFF171620),
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        colors: [Color(0xff1a112a), Color(0xff2a1733), Color(0xff1a112a)],
        stops: [0.10, 0.5, 0.90],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      )),
      child: SafeArea(
        child: home(),
      ),
    ));
  }

  Widget home() {
    // var currentScreen =
    //     Provider.of<HomeScreenStateProvider>(context, listen: false);
    return Stack(
      children: [
        Column(
          children: [
            Consumer<RadioManagerProvider>(
              builder: (context, RadioManagerProvider radioManager, _) {
                var currentRadioStation = radioManager.currentRadioStation;

                return SizedBox(
                  height: 96,
                  child: currentRadioStation != null
                      ? CurrentRadioStation(
                          radioStation: currentRadioStation,
                          isPlaying: radioManager.radioStatus.isPlaying,
                          onTap: () {
                            context.push(RouteNames.detail);
                          },
                        )
                      : Consumer<HomeScreenStateProvider>(
                          builder: (context,
                              HomeScreenStateProvider homeScreenState, _) {
                            switch (homeScreenState.currentScreen) {
                              case HomeScreenPages.mainList:
                                return title(
                                    'Top Radios', 'Top 300 radios of spain');
                              case HomeScreenPages.favorites:
                                return title(
                                    'Favorites', 'Your favorite radios');
                              case HomeScreenPages.search:
                                return title('Explore', 'Discover new radios');
                            }
                          },
                        ),
                );
              },
            ),
            Expanded(
                child: PageView.builder(
              controller:
                  Provider.of<HomeScreenStateProvider>(context, listen: false)
                      .pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {
                switch (
                    Provider.of<HomeScreenStateProvider>(context, listen: false)
                        .currentScreen) {
                  case HomeScreenPages.mainList:
                    return const MainListPage();
                  case HomeScreenPages.favorites:
                    return const FavoritesPage();
                  case HomeScreenPages.search:
                    return ChangeNotifierProvider<ExplorePageProvider>(
                        create: (context) => ExplorePageProvider(),
                        child: const ExplorePage());
                }
              },
            )),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Consumer2<RadioManagerProvider, HomeScreenStateProvider>(
                builder: (context, RadioManagerProvider radioManager,
                    HomeScreenStateProvider homeScreenState, _) {
              return BottomBar(
                radioStatus: radioManager.radioStatus,
                onMediaTap: () {
                  if (radioManager.currentRadioStation == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.background2,
                          ),
                          child: const Text(
                            'Select a radio station first',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      ),
                    );
                  }
                  radioManager.playOrPause();
                },
                children: [
                  SelectableIconButton(
                    Icons.radio_outlined,
                    isSelected: homeScreenState.currentScreen ==
                        HomeScreenPages.mainList,
                    onTap: () =>
                        homeScreenState.onTabTapped(HomeScreenPages.mainList),
                  ),
                  SelectableIconButton(
                    CupertinoIcons.search,
                    isSelected:
                        homeScreenState.currentScreen == HomeScreenPages.search,
                    onTap: () =>
                        homeScreenState.onTabTapped(HomeScreenPages.search),
                  ),
                  SelectableIconButton(
                    CupertinoIcons.heart,
                    isSelected: homeScreenState.currentScreen ==
                        HomeScreenPages.favorites,
                    onTap: () =>
                        homeScreenState.onTabTapped(HomeScreenPages.favorites),
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget title(String title, String subtitle) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
