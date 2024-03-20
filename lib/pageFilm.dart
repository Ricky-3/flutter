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
  // Déclaration des variables qui sont demandées
  double? lat;
  double? lon;
  String description = '';
  double? temp;
  double? tempMax;
  double? tempMin;
  double? vitesseDuVent;
  int? pression;
  int? humidite;
  int? directionDuVent;
  String icon = '';
  Map<String, dynamic>? donneeMeteo; //stocke les données météorologiques

  @override
  void initState() {
    super.initState();
    getData(); // Récupère les données au moment où le widget est créé
  }

  @override
  Widget build(BuildContext context) {
    // structure de la page
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Météo d\'Orléans'), // Titre de l'AppBar
      ),
      body: Center(       // Centre le child dans son conteneur
        child: Column(   // Colonne pour aligner les children verticalement
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(
              'http://openweathermap.org/img/w/$icon.png',
              width: 100,
              height: 100,
              fit: BoxFit.cover, // Couvre la boîte sans déformer l'image
            ),
            // Affichage des données météorologiques
            Text('Latitude: $lat'),
            Text('Longitude: $lon'),
            Text('Description: $description'),
            Text('Température: $temp°C'),
            Text('Température Maximale: $tempMax°C'),
            Text('Température Minimale: $tempMin°C'),
            Text('Vitesse du Vent: $vitesseDuVent  m/s'),
            Text('Pression Atmosphérique: $pression  hPa'),
            Text('Humidité: $humidite%'),
            Text('Direction du Vent: $directionDuVent°'),
          ],
        ),
      ),
    );
  }

  // Fonction pour récupérer les données météorologiques depuis l'API OpenWeatherMap
  Future<void> getData() async {
    const apiKey = '3f2333bd5cd4789ce6a31a5d10e814ba';
    const latitude = '47.9022'; // Latitude d'Orléans
    const longitude = '1.9040'; // Longitude d'Orléans
    final url = Uri.parse( //API
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric&lang=fr');

    //requête HTTP à l'API
    final response = await http.get(url);
    final Map<String, dynamic> data = json.decode(response.body);

    // Met à jour l'état avec les données météorologiques récupérées
    setState(() {
      donneeMeteo = data; // Stocke toutes les données météorologiques
      lat = data['coord']['lat'];
      lon = data['coord']['lon'];
      description = data['weather'][0]['description'];
      temp = data['main']['temp'];
      tempMax = data['main']['temp_max'];
      tempMin = data['main']['temp_min'];
      vitesseDuVent = data['wind']['speed'];
      pression = data['main']['pressure'];
      humidite = data['main']['humidity'];
      vitesseDuVent = data['wind']['speed'];
      directionDuVent = data['wind']['deg'];
      icon = data['weather'][0]['icon']; //icone de la météo
    });
  }
}
