import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Fonction pour envoyer une prompte à ChatGPT et obtenir une réponse
Future<String> envoyerPrompteAChatGPT(String prompte) async {
  // Remplacez 'VOTRE_CLÉ_API' par votre clé API réelle
  const apiKey = 'VOTRE_CLÉ_API';
  // URL de l'API d'OpenAI pour ChatGPT
  const url = 'https://api.openai.com/v1/completions';

  // Paramètres de la requête
  final body = jsonEncode({
    'model': 'text-davinci-003', // Spécifiez le modèle de ChatGPT à utiliser
    'prompt': prompte, // La prompte envoyée à ChatGPT
    'temperature': 0.7, // Contrôle la créativité de la réponse
    'max_tokens': 150, // Nombre maximum de tokens dans la réponse
  });

  // En-têtes de la requête, y compris la clé API
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $apiKey',
  };

  try {
    // Exécution de la requête POST à l'API d'OpenAI
    final response = await http.post(Uri.parse(url), headers: headers, body: body);

    // Vérification si la requête a réussi
    if (response.statusCode == 200) {
      // Décodage de la réponse JSON
      final responseData = jsonDecode(response.body);
      // Extraction et retour de la réponse de ChatGPT
      return responseData['choices'][0]['text'];
    } else {
      // Gestion des erreurs de requête
      return 'Erreur lors de la récupération de la réponse: ${response.statusCode}';
    }
  } catch (e) {
    // Gestion des exceptions
    return 'Erreur lors de l\'envoi de la requête: $e';
  }
}

// Fonction principale pour tester la communication avec ChatGPT
void main() async {
  // Exemple de prompte à envoyer
  const prompte = 'Quel est ton film préféré ?';
  // Obtention de la réponse de ChatGPT
  final reponse = await envoyerPrompteAChatGPT(prompte);
  print('Réponse de ChatGPT: $reponse');
}

