import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'api.dart';
import 'connexion.dart';
import 'globals.dart';

void main() async {

  // On utilise la méthode "fetchMostPlayedGames" de la classe "Api"
  // pour retourner une liste de jeux les plus joués
  final games = await Api.fetchMostPlayedGames();

  // On utilise une boucle "for" pour parcourir chaque jeu de la liste "games"
  for (var game in games) {

    // On ajoute l'ID de chaque jeu à une autre liste nommée "gameIds"
    gameIds.add(game.id);

  }

  // On utilise une autre boucle "for" pour parcourir chaque ID de jeu dans la liste "gameIds"
  for (var i = 0; i < gameIds.length; i++) {

    try {

      // On utilise la méthode "fetchGame" de la classe "Api" retournant les détails d'un jeu spécifique avec l'ID
      final gameDetails = await Api.fetchGame(gameIds[i]);

      // On ajoute le nom de chaque jeu à une autre liste nommée "gameNames"
      gameNames.add(gameDetails.name);

      // On crée un nouvel objet "Game" à partir des détails du jeu et on l'ajoute à une liste nommée "gamesList"
      gamesList.add(Game(id: gameIds[i], name: gameDetails.name, publisher: gameDetails.publisher, price: gameDetails.price));

    } catch (e) {

      // Si une erreur se produit lors de la récupération des détails d'un jeu,
      // on affiche un message d'erreur avec l'ID du jeu concerné et le message d'erreur lui-même
      print('Error fetching game details for game ID: ${gameIds[i]}');
      print('Error message: $e');
    }

  }

  // On s'assure que les widgets Flutter sont initialisés
  WidgetsFlutterBinding.ensureInitialized();

  // On s'assure que Firebase soit initialisé
  await Firebase.initializeApp();

  // L'instance de SharedPreferences est récupérée
  // 0n utilise la méthode "clear" pour effacer toutes les préférences stockées dans l'instance
  await SharedPreferences.getInstance().then((prefs) {
    prefs.clear();
  });

  // On vide les listes "gameLikeID" et "gameWishID"
  gameLikeID.clear();
  gameWishID.clear();

  return runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Connexion(),
    );
  }
}
