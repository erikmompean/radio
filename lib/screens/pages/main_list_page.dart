import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio/enum/data_state.dart';
import 'package:radio/providers/models/main_list_page_provider.dart';
import 'package:radio/providers/radio_manager_provider.dart';
import 'package:radio/providers/radio_storage_provider.dart';
import 'package:radio/widgets/loading_indicator.dart';
import 'package:radio/widgets/radio_station_list_item.dart';

class MainListPage extends StatefulWidget {
  const MainListPage({super.key});

  @override
  State<MainListPage> createState() => _MainListPageState();
}

class _MainListPageState extends State<MainListPage> {
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    var radioManager =
        Provider.of<RadioManagerProvider>(context, listen: false);
    var storageProvider =
        Provider.of<RadioStorageProvider>(context, listen: false);

    return Consumer<MainListPageProvider>(
        builder: (context, mainListPageProvider, child) {
      var radioStations = mainListPageProvider.radioStations;
      return mainListPageProvider.dataStatus.isLoading
          ? const Center(child: LoadingIndicator())
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 100),
              itemCount: radioStations.length,
              itemBuilder: (context, index) => Consumer<RadioStorageProvider>(
                builder: (context, value, child) {
                  return RadioStationListItem(
                    radioStation: radioStations[index],
                    isFavorite:
                        storageProvider.checkFavourite(radioStations[index]),
                    onTap: () {
                      radioManager.setCurrentRadioStation(radioStations[index]);
                    },
                    onFavouriteTap: () =>
                        storageProvider.toggleFavorite(radioStations[index]),
                  );
                },
              ),
            );
    });
  }
}
