import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:radio/enum/radio_status.dart';
import 'package:radio/providers/radio_manager_provider.dart';
import 'package:radio/providers/radio_storage_provider.dart';
import 'package:radio/providers/volume_manager_provider.dart';
import 'package:radio/utils/app_colors.dart';
import 'package:radio/utils/standard.dart';
import 'package:radio/widgets/delayed_backdrop_filter.dart';
import 'package:radio/widgets/icon_mask.dart';
import 'package:radio/widgets/scale_animation_button.dart';
import 'package:radio/widgets/speaker_animation.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<VolumeManagerProvider>(context, listen: false).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentRadioStation =
        Provider.of<RadioManagerProvider>(context).currentRadioStation!;
    return Scaffold(
      body: DelayedBackdropFilter(
        delay: const Duration(milliseconds: 500),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Opacity(
              opacity: 0.9,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xff1a112a),
                      Color(0xff2a1733),
                      Color(0xff1a112a)
                    ],
                    stops: [0.10, 0.5, 0.90],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        ScaleAnimationButton(
                          onTap: () {
                            context.pop();
                          },
                          child: Container(
                            color: Colors.transparent,
                            width: 50,
                            height: 50,
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Consumer<RadioManagerProvider>(
                            builder: (context, radioManager, _) {
                          return SpeakerAnimation(
                            on: radioManager.radioStatus.isPlaying,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(Standard.borderRadius),
                              child: SizedBox(
                                width: 140,
                                height: 140,
                                child: Image.network(
                                    Provider.of<RadioManagerProvider>(context)
                                        .currentRadioStation!
                                        .favicon!),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            currentRadioStation.name,
                            maxLines: 2,
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                fontSize: 24,
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Consumer<RadioStorageProvider>(
                          builder: (context, storageProvider, _) {
                            return ScaleAnimationButton(
                              onTap: () {
                                storageProvider
                                    .toggleFavorite(currentRadioStation);
                              },
                              child: storageProvider
                                      .checkFavourite(currentRadioStation)
                                  ? const Icon(CupertinoIcons.heart_fill,
                                      color: AppColors.primary)
                                  : const Icon(CupertinoIcons.heart,
                                      color: Colors.white),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      runSpacing: 4,
                      children: currentRadioStation.tags
                          .map(
                            (tag) => Container(
                              constraints: const BoxConstraints(maxWidth: 100),
                              margin: const EdgeInsets.only(right: 5),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 2),
                              decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                tag.split(' ').first,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    Expanded(
                      child: Center(
                        child: ScaleAnimationButton(
                            onTap: () {
                              Provider.of<RadioManagerProvider>(context,
                                      listen: false)
                                  .playOrPause();
                            },
                            child: IconMask(
                              child: Icon(
                                Provider.of<RadioManagerProvider>(context,
                                            listen: false)
                                        .radioStatus
                                        .isPlaying
                                    ? CupertinoIcons.pause_fill
                                    : CupertinoIcons.play_fill,
                                color: Colors.white,
                                size: 70,
                              ),
                            )),
                      ),
                    ),
                    Consumer<VolumeManagerProvider>(
                        builder: (context, volumeManager, _) {
                      return Row(children: [
                        IconMask(
                          child: volumeManager.volume == 0
                              ? const Icon(CupertinoIcons.volume_off,
                                  color: Colors.white)
                              : const Icon(CupertinoIcons.volume_up,
                                  color: Colors.white),
                        ),
                        Expanded(
                          child:
                              volumeSlider(volumeManager.volume, (value) async {
                            await volumeManager.setVolume(value);
                          }),
                        ),
                      ]);
                    }),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget volumeSlider(double volume, Function(double) onChanged) {
    return CupertinoSlider(
      value: volume,
      onChanged: onChanged,
      activeColor: AppColors.primary,
      min: 0.0,
      max: 1.0,
    );
  }
}
