import 'package:flutter/material.dart';
import 'package:netflix_clone/common/utlis.dart';
import 'package:netflix_clone/models/tv_series_model.dart';
import 'package:netflix_clone/models/upcoming_model.dart';
import 'package:netflix_clone/screens/search_screen.dart';
import 'package:netflix_clone/services/api_services.dart';
import 'package:netflix_clone/widgets/custom_curosal.dart';
import 'package:netflix_clone/widgets/moive_card_wiidget.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  late Future<UpcomingMovieModel> upComingFuture;
  late Future<UpcomingMovieModel> nowPlayingFuture;
  late Future<TvSeriesModel> topRatedSeries;

  ApiServices apiServices = ApiServices();
  @override
  void initState() {
    super.initState();
    upComingFuture = apiServices.getUpComingMovies();
    nowPlayingFuture = apiServices.getNowPlayingMovies();
    topRatedSeries = apiServices.getTopRatedSeries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kBackgroudColor,
          title: Image.asset(
            "assets/logo (2).png",
            height: 50,
            width: 120,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SearchScreen()));
                  },
                  child: const Icon(
                    Icons.search,
                    size: 30,
                    color: Colors.white,
                  )),
            ),
            const SizedBox(width: 20),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  color: Colors.blue,
                  height: 27,
                  width: 27,
                ),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder<TvSeriesModel>(
                  future: topRatedSeries,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return CustomCurosal(data: snapshot.data!);
                    } else {
                      return const SizedBox.shrink();
                    }
                  }),
              SizedBox(
                height: 250,
                child: MoiveCardWiidget(
                    future: nowPlayingFuture,
                    headLineText: "Now Playing Movies"),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 250,
                child: MoiveCardWiidget(
                    future: upComingFuture, headLineText: "Upcoming Movies"),
              ),
            ],
          ),
        ));
  }
}
