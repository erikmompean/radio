import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio/enum/radio_status.dart';
import 'package:radio/models/radio_station.dart';
import 'package:radio/providers/radio_manager_provider.dart';
import 'package:radio/utils/app_colors.dart';
import 'package:radio/widgets/scale_animation_button.dart';
import 'package:radio/widgets/speaker_animation.dart';

class CurrentRadioStation extends StatelessWidget {
  final RadioStation radioStation;
  final bool isPlaying;
  final Function() onTap;
  const CurrentRadioStation(
      {super.key,
      required this.radioStation,
      required this.onTap,
      required this.isPlaying});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          image(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(isPlaying ? 'Currently playing...' : 'Paused',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.white)),
                    const SizedBox(height: 5),
                    Text(radioStation.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white)),
                  ],
                ),
              ),
            ),
          ),
          ScaleAnimationButton(
            onTap: () => onTap(),
            child: Container(
              color: Colors.transparent,
              width: 50,
              height: 50,
              child:
                  const Icon(CupertinoIcons.chevron_down, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget image() {
    return radioStation.favicon != null && radioStation.favicon!.isNotEmpty
        ? blurredImage()
        : const Icon(Icons.settings_input_antenna,
            size: 50, color: Colors.white);
  }

  Widget blurredImage() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              fit: BoxFit.cover,
              // Probably fix: https://stackoverflow.com/questions/73447581/flutter-how-to-handle-networkimage-with-invalid-image-data-exception
              image: NetworkImage(
                radioStation.favicon!,
              ),
              onError: (exception, stackTrace) => const Icon(
                Icons.broken_image,
                size: 30,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 54,
          width: 54,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaX: 22.0, sigmaY: 22.0, tileMode: TileMode.clamp),
              child: Consumer<RadioManagerProvider>(
                builder: (context, RadioManagerProvider radioManager, _) {
                  return SpeakerAnimation(
                    on: radioManager.radioStatus.isPlaying,
                    child: Image.network(
                      radioStation.favicon!,
                      width: 54,
                      height: 54,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
