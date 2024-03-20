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

  // Variables pour la recherche
  TextEditingController _searchController = TextEditingController();
  String _searchText = '';

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
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Cinematch',
              style: TextStyle(color: Colors.red), // Texte en rouge pour Cinematch
            ),
            SizedBox(width: 20),
            Expanded(
              child: TextField(
                controller: _searchController,
                style: TextStyle(color: Colors.white), // Texte en blanc pour la barre de recherche
                decoration: InputDecoration(
                  hintText: 'Rechercher...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)), // Couleur de texte en blanc avec opacité
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchText = value;
                  });
                },
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _searchText = _searchController.text;
                });
              },
              icon: Icon(Icons.search, color: Colors.white), // Icône de recherche en blanc
            ),
          ],
        ),
        backgroundColor: Colors.black,
      ),
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
            FilmList(films: _searchText.isEmpty ? films : _filterFilms(), filmImages: filmImages), // Utilisation du widget FilmList
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text('Séries TV', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 10),
            SerieList(series: _searchText.isEmpty ? series : _filterSeries(), serieImages: serieImages), // Utilisation du widget SerieList
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
  // Fonction pour filtrer les films en fonction du texte de recherche
  List<dynamic>? _filterFilms() {
    if (_searchText.isEmpty) {
      return films;
    } else {
      List<dynamic>? filteredFilms = films
          ?.where((film) =>
          film['title'].toString().toLowerCase().contains(_searchText.toLowerCase()))
          .toList();

      // Créer une nouvelle liste d'images filtrées pour les films filtrés
      List<String>? filteredFilmImages = [];

      // Parcourir les films filtrés et ajouter les images correspondantes à la nouvelle liste
      for (var film in filteredFilms!) {
        int index = films!.indexOf(film);
        if (index != -1 && index < filmImages!.length) {
          filteredFilmImages.add(filmImages![index]);
        }
      }

      // Mettre à jour la liste des images filtrées
      filmImages = filteredFilmImages;

      return filteredFilms;
    }
  }
  // Fonction pour filtrer les séries TV en fonction du texte de recherche
  List<dynamic>? _filterSeries() {
    return series
        ?.where((serie) => serie['name'].toString().toLowerCase().contains(_searchText.toLowerCase()))
        .toList();
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
