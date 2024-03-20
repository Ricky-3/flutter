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
        backgroundColor: Colors.black,
        title: const Text('CineMatch', style: TextStyle(color: Colors.red)),
      ),
      backgroundColor: Colors.black,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Accueil', style: TextStyle(color: Colors.black)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            // Ajouter d'autres options du menu ici au besoin
          ],
        ),
      ),
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
            SizedBox(
              height: 240,
              child: PageView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: films?.length ?? 0,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(filmImages![index], width: 160, fit: BoxFit.cover),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(films![index]['title'], style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('${films![index]['release_date']}', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text('Séries TV', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 240,
              child: PageView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: series?.length ?? 0,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(serieImages![index], width: 160, fit: BoxFit.cover),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(series![index]['name'], style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('${series![index]['first_air_date']}', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  );
                },
              ),
            ),
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
