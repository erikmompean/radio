import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:radio/enum/data_state.dart';
import 'package:radio/providers/models/countries_screen_provider.dart';
import 'package:radio/routes/route_names.dart';
import 'package:radio/widgets/loading_indicator.dart';
import 'package:radio/widgets/scale_animation_button.dart';

class CountriesScreen extends StatefulWidget {
  const CountriesScreen({super.key});

  @override
  State<CountriesScreen> createState() => _CountriesScreenState();
}

class _CountriesScreenState extends State<CountriesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<CountriesScreenProvider>(context, listen: false).initialize();
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
        Consumer(
          builder: (context, CountriesScreenProvider countriesProvider, _) {
            if (countriesProvider.dataState.isLoading) {
              return const Expanded(child: Center(child: LoadingIndicator()));
            }
            if (countriesProvider.dataState.isError) {
              return const Expanded(
                  child: Center(child: Text('Error loading data')));
            }

            return Expanded(
              child: GridView.builder(
                itemCount: countriesProvider.countries.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.3,
                ),
                itemBuilder: (context, index) {
                  var country = countriesProvider.countries[index];
                  return ScaleAnimationButton(
                    onTap: () {
                      context.push(
                        RouteNames.searcher,
                        extra: country.name,
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xff2a1733),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          CountryFlag.fromCountryCode(
                            country.code,
                            width: 40,
                            height: 30,
                            shape: const RoundedRectangle(6),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                country.name,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                'Countries',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Select a country to see the radio stations',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
