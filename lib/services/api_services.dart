import 'dart:convert';
import 'dart:developer';

import 'package:netflix_clone/common/utlis.dart';
import 'package:netflix_clone/models/movie_detail_model.dart';
import 'package:netflix_clone/models/movie_recommendation_mode.dart';
import 'package:netflix_clone/models/search_model.dart';
import 'package:netflix_clone/models/tv_series_model.dart';
import 'package:netflix_clone/models/upcoming_model.dart';
import 'package:http/http.dart' as http;

const baseUrl = "https://api.themoviedb.org/3/";
var key = "?api_key=$apiKye";
late String endPoint;

class ApiServices {
  Future<UpcomingMovieModel> getUpComingMovies() async {
    endPoint = "movie/upcoming";
    final url = "$baseUrl$endPoint$key";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      log("Success responde");
      return UpcomingMovieModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failer to load upcoming movies");
  }

  Future<UpcomingMovieModel> getNowPlayingMovies() async {
    endPoint = "movie/now_playing";
    final url = "$baseUrl$endPoint$key";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      log("Success responde");
      return UpcomingMovieModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failer to load now playing movies");
  }

  // Future<TvSeriesModel> getTopRatedSieris() async {
  //   endPoint = "tv/top_rated";
  //   final url = "$baseUrl$endPoint$key";
  //   final response = await http.get(Uri.parse(url));
  //   if (response.statusCode == 200) {
  //     log("Success responde");
  //     return TvSeriesModel.fromJson(jsonDecode(response.body));
  //   }
  //   throw Exception("Failer to load top rated tseries");
  // }
  Future<TvSeriesModel> getTopRatedSeries() async {
    endPoint = 'tv/1396/recommendations';
    final url = '$baseUrl$endPoint$key';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      log('success');
      return TvSeriesModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('failed to load top rated series');
  }

  Future<SearchModel> getSearchedMovie(String searchText) async {
    endPoint = 'search/movie?query=$searchText';
    final url = '$baseUrl$endPoint';
    print(url);
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3NTAyYjhjMDMxYzc5NzkwZmU1YzBiNGY5NGZkNzcwZCIsInN1YiI6IjYzMmMxYjAyYmE0ODAyMDA4MTcyNjM5NSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.N1SoB26LWgsA33c-5X0DT5haVOD4CfWfRhwpDu9eGkc'
    });
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      log('success');
      return SearchModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('failed to load  search movie ');
  }

  Future<MovieRecommendationsModel> getPopularMovies() async {
    endPoint = "movie/popular";
    final url = "$baseUrl$endPoint$key";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      log("Success responde");
      return MovieRecommendationsModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failer to load popular movies");
  }

  Future<MovieDetailModel> getMovieDetails(int movieId) async {
    endPoint = 'movie/$movieId';
    final url = '$baseUrl$endPoint$key';
    print(url);
    final response = await http.get(
      Uri.parse(url),
    );
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      log('success');
      return MovieDetailModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('failed to movie detailes ');
  }

  Future<MovieRecommendationsModel> getMovieRecommendation(int movieId) async {
    endPoint = 'movie/$movieId/recommendations';
    final url = '$baseUrl$endPoint$key';
    print(url);
    final response = await http.get(
      Uri.parse(url),
    );
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      log('success');
      return MovieRecommendationsModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('failed to load more like this ');
  }
}
