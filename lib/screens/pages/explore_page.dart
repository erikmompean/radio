import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:radio/routes/route_names.dart';
import 'package:radio/widgets/icon_mask.dart';
import 'package:radio/widgets/scale_animation_button.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: item(
                    CupertinoIcons.globe, 'Search All', 'Search all radios',
                    () {
                  context.push(RouteNames.searcher);
                }),
              ),
              Expanded(
                child: item(CupertinoIcons.flag, 'By country',
                    'Find radios from other places', () {
                  context.push(RouteNames.countries);
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget item(
      IconData icon, String title, String description, Function() onTap) {
    return SizedBox(
      height: 120,
      child: ScaleAnimationButton(
        onTap: () => onTap(),
        child: Card(
          color: const Color(0xff2a1733),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconMask(
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
