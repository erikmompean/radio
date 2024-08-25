import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:radio/enum/data_state.dart';
import 'package:radio/providers/models/searcher_screen_provider.dart';
import 'package:radio/providers/radio_manager_provider.dart';
import 'package:radio/providers/radio_storage_provider.dart';
import 'package:radio/utils/app_colors.dart';
import 'package:radio/widgets/loading_indicator.dart';
import 'package:radio/widgets/radio_station_list_item.dart';
import 'package:radio/widgets/scale_animation_button.dart';

class SearcherScreen extends StatefulWidget {
  const SearcherScreen({super.key});

  @override
  State<SearcherScreen> createState() => _SearcherScreenState();
}

class _SearcherScreenState extends State<SearcherScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<SearcherScreenProvider>(context, listen: false)
          .initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        colors: [Color(0xff1a112a), Color(0xff2a1733), Color(0xff1a112a)],
        stops: [0.10, 0.5, 0.90],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      )),
      child: SafeArea(
        child: body(context),
      ),
    ));
  }

  Widget body(BuildContext context) {
    return Column(
      children: [
        topElements(context),
        Consumer2<SearcherScreenProvider, RadioStorageProvider>(
          builder: (context, SearcherScreenProvider searcherProvider,
              RadioStorageProvider storage, _) {
            if (searcherProvider.dataState.isLoading) {
              return const Expanded(child: Center(child: LoadingIndicator()));
            }
            if (searcherProvider.dataState.isError) {
              return const Center(child: Text('Error loading data'));
            }

            if (searcherProvider.dataState.isUnInitialized &&
                searcherProvider.filteredRadioStations.isEmpty) {
              return const Expanded(
                  child: Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                    child: Text(
                  'What are you waiting? Search cool radios!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                )),
              ));
            }
            return Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: searcherProvider.filteredRadioStations.length,
                itemBuilder: (context, index) {
                  var radio = searcherProvider.filteredRadioStations[index];
                  return RadioStationListItem(
                    radioStation: radio,
                    isFavorite: storage.checkFavourite(radio),
                    onTap: () => Provider.of<RadioManagerProvider>(context,
                            listen: false)
                        .setCurrentRadioStation(radio),
                    onFavouriteTap: () => storage.toggleFavorite(radio),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget topElements(BuildContext context) {
    final searcherScreenProvider =
        Provider.of<SearcherScreenProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          Row(
            children: [
              ScaleAnimationButton(
                onTap: () {
                  context.pop();
                },
                child: Container(
                  width: 40,
                  height: 40,
                  color: Colors.transparent,
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              const Text(
                'Searcher',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: searcherScreenProvider.searchController,
            cursorColor: AppColors.primary,
            decoration: const InputDecoration(
              hintText: 'Search...',
              hintStyle:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary),
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
            ),
            style: const TextStyle(color: Colors.white),
            onChanged: (value) async => searcherScreenProvider.search(value),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
