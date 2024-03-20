import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'design.dart';
import 'film_list.dart'; // Importation du widget FilmList
import 'serie_list.dart'; // Importation du widget SerieList

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

  // Map des codes de langue vers leurs noms complets
  final Map<String, String> languages = {
    'en': 'Anglais',
    'fr': 'Français',
    'it': 'Italien',
    'es': 'Espagnol',
    // Ajouter d'autres langues au besoin
  };

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Cinematch'),
      backgroundColor: Colors.black,
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text('Films', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 10),
            FilmList(films: films, filmImages: filmImages), // Utilisation du widget FilmList
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text('Séries TV', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 10),
            SerieList(series: series, serieImages: serieImages), // Utilisation du widget SerieList
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Fonction pour récupérer le nom complet de la langue
  String getLanguage(String languageCode) {
    return languages[languageCode] ?? 'Anglais';
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
