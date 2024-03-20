import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class PageFilm extends StatefulWidget {
  const PageFilm({Key? key}) : super(key: key);

  @override
  State<PageFilm> createState() => _PageFilmState();
}

class _PageFilmState extends State<PageFilm> {
  List<dynamic>? films;
  List<dynamic>? series;
  List<String>? filmImages; // Pour stocker les chemins d'accès aux images des films
  List<String>? serieImages; // Pour stocker les chemins d'accès aux images des séries TV

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Films et Séries TV'),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            if (films != null && filmImages != null)
              Column(
                children: [
                  const Text('Films:'),
                  for (int i = 0; i < films!.length; i++)
                    ListTile(
                      title: Text(films![i]['title']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Date: ${films![i]['release_date']}'),
                          Text('Langue: ${films![i]['original_language']}'),
                        ],
                      ),
                      leading: Image.network(filmImages![i]), // Affichage de l'image du film
                      onTap: () {
                        // Afficher plus de détails sur le film si nécessaire
                      },
                    ),
                ],
              ),
            if (series != null && serieImages != null)
              Column(
                children: [
                  const Text('Séries TV:'),
                  for (int i = 0; i < series!.length; i++)
                    ListTile(
                      title: Text(series![i]['name']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Date: ${series![i]['first_air_date']}'),
                          Text('Langue: ${series![i]['original_language']}'),
                        ],
                      ),
                      leading: Image.network(serieImages![i]), // Affichage de l'image de la série TV
                      onTap: () {
                        // Afficher plus de détails sur la série TV si nécessaire
                      },
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  // Fonction pour récupérer les données à partir de l'API de TMDb
  Future<void> getData() async {
    const apiKey = '39cbf5c7b31a8d7cc93d49ef3c6a595c';
    final filmsUrl = Uri.parse('https://api.themoviedb.org/3/movie/popular?api_key=$apiKey&language=fr-FR&page=1');
    final seriesUrl = Uri.parse('https://api.themoviedb.org/3/tv/popular?api_key=$apiKey&language=fr-FR&page=1');

    // Requête HTTP pour les films
    final filmsResponse = await http.get(filmsUrl);
    final filmsData = json.decode(filmsResponse.body);
    final List<String> filmsImageUrls = [];
    for (var film in filmsData['results']) {
      filmsImageUrls.add('https://image.tmdb.org/t/p/w500${film['poster_path']}');
    }

    // Requête HTTP pour les séries TV
    final seriesResponse = await http.get(seriesUrl);
    final seriesData = json.decode(seriesResponse.body);
    final List<String> seriesImageUrls = [];
    for (var serie in seriesData['results']) {
      seriesImageUrls.add('https://image.tmdb.org/t/p/w500${serie['poster_path']}');
    }

    setState(() {
      films = filmsData['results'];
      filmImages = filmsImageUrls;
      series = seriesData['results'];
      serieImages = seriesImageUrls;
    });
  }
}
