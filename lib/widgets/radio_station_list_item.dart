import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:radio/models/radio_station.dart';
import 'package:radio/utils/app_colors.dart';
import 'package:radio/widgets/scale_animation_button.dart';

class RadioStationListItem extends StatelessWidget {
  final RadioStation radioStation;
  final Function() onTap;
  final Function() onFavouriteTap;
  final bool isFavorite;
  const RadioStationListItem(
      {super.key,
      required this.radioStation,
      required this.isFavorite,
      required this.onTap,
      required this.onFavouriteTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 10),
      child: SizedBox(
        height: 80,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: SizedBox(
                  width: 40,
                  height: 40,
                  child: radioStation.favicon != null &&
                          radioStation.favicon!.isNotEmpty
                      ? FadeInImage.assetNetwork(
                          image: radioStation.favicon!,
                          placeholder: 'assets/images/transparent-image.png',
                          imageErrorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.broken_image_outlined,
                                size: 30,
                                color: AppColors.primary,
                              ))
                      : const Icon(Icons.settings_input_antenna)),
            ),
            const SizedBox(width: 10),
            infoCard(),
          ],
        ),
      ),
    );
  }

  Widget tags(List<String> allTags) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var tagMaxWidth = (constraints.maxWidth - 15) / 3;
        return Row(
          children: allTags
              .take(3)
              .map((tag) => Container(
                    constraints: BoxConstraints(maxWidth: tagMaxWidth),
                    margin: const EdgeInsets.only(right: 5),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(tag.split(' ').first,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        )),
                  ))
              .toList(),
        );
      },
    );
  }

  Widget infoCard() {
    return Expanded(
      child: ScaleAnimationButton(
        onTap: () => onTap(),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40), bottomLeft: Radius.circular(40)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40), bottomLeft: Radius.circular(40)),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xff2a1733),
                    Color(0xff1a112a),
                  ],
                  stops: [0.25, 0.75],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5),
                            Text(radioStation.name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.white)),
                            tags(radioStation.tags),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      ScaleAnimationButton(
                        onTap: () => onFavouriteTap(),
                        child: isFavorite
                            ? const Icon(
                                CupertinoIcons.heart_fill,
                                color: AppColors.primary,
                              )
                            : const Icon(CupertinoIcons.heart,
                                color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
