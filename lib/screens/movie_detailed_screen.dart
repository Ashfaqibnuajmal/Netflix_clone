import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:netflix_clone/common/utlis.dart';
import 'package:netflix_clone/models/movie_detail_model.dart';
import 'package:netflix_clone/models/movie_recommendation_mode.dart';
import 'package:netflix_clone/services/api_services.dart';

class MovieDetailedScreen extends StatefulWidget {
  final int movieId;
  const MovieDetailedScreen({super.key, required this.movieId});

  @override
  State<MovieDetailedScreen> createState() => _MovieDetailedScreenState();
}

class _MovieDetailedScreenState extends State<MovieDetailedScreen> {
  ApiServices apiServices = ApiServices();
  late Future<MovieDetailModel> movieDetail;
  late Future<MovieRecommendationsModel> movieRecommendations;

  @override
  void initState() {
    fetchInitialData();
    super.initState();
  }

  fetchInitialData() {
    movieDetail = apiServices.getMovieDetails(widget.movieId);
    movieRecommendations = apiServices.getMovieRecommendation(widget.movieId);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print(widget.movieId);
    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder(
            future: movieDetail,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final movie = snapshot.data;
                String genereText =
                    movie!.genres.map((genere) => genere.name).join(', ');
                return Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.4,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      "$imageUrl${movie.posterPath}"),
                                  fit: BoxFit.cover)),
                          child: SafeArea(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title,
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Text(
                              movie.releaseDate.year.toString(),
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 30),
                            Text(
                              genereText,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 13),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(movie.overview,
                            maxLines: 6,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 17))
                      ],
                    ),
                    const SizedBox(height: 30),
                    FutureBuilder(
                        future: movieRecommendations,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final movie = snapshot.data;
                            return movie!.results.isEmpty
                                ? const SizedBox()
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text("More like this"),
                                      const SizedBox(height: 20),
                                      GridView.builder(
                                        padding: const EdgeInsets.all(0),
                                        itemCount: movie.results.length,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 3,
                                                mainAxisSpacing: 15,
                                                crossAxisSpacing: 5,
                                                childAspectRatio: 1.5 / 2),
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MovieDetailedScreen(
                                                              movieId: movie
                                                                  .results[
                                                                      index]
                                                                  .id)));
                                            },
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  "$imageUrl${movie.results[index].posterPath}",
                                            ),
                                          );
                                        },
                                      )
                                    ],
                                  );
                          }
                          return const Text("something went wrong");
                        })
                  ],
                );
              } else {
                return const SizedBox();
              }
            }),
      ),
    );
  }
}
