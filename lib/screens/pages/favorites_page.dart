import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio/models/radio_station.dart';
import 'package:radio/providers/radio_manager_provider.dart';
import 'package:radio/providers/radio_storage_provider.dart';
import 'package:radio/utils/app_colors.dart';
import 'package:radio/widgets/scale_animation_button.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    var radioManager =
        Provider.of<RadioManagerProvider>(context, listen: false);
    return Consumer(
        builder: (context, RadioStorageProvider storageProvider, child) {
      var favoriteRadios = storageProvider.favorites;

      if (favoriteRadios.isEmpty) {
        return const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No favorites yet',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(height: 20),
            Icon(Icons.favorite_border, color: AppColors.primary, size: 50)
          ],
        );
      }
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: storageProvider.favorites.length,
        itemBuilder: (context, index) {
          var favoriteRadio = favoriteRadios[index];
          return ScaleAnimationButton(
              onTap: () => radioManager.setCurrentRadioStation(favoriteRadio),
              child: item(favoriteRadio, () async {
                await storageProvider.toggleFavorite(favoriteRadio);
              }));
        },
      );
    });
  }

  Widget item(RadioStation favoriteRadio, Function() onFavoriteTap) {
    return Card(
      color: const Color(0xff2a1733),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              favoriteRadio.name,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    favoriteRadio.country,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
                ScaleAnimationButton(
                  onTap: () => onFavoriteTap.call(),
                  child: Container(
                    height: 30,
                    width: 30,
                    color: Colors.transparent,
                    child: const Icon(Icons.favorite,
                        color: AppColors.primary, size: 20),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
