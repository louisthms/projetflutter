import 'dart:convert';
import 'package:http/http.dart' as http;

class Api{

  // Méthode qui récupère les détails d'un jeu en utilisant son ID

  static Future<GameDetails> fetchGameDetails(int gameId) async {

    // On envoie une requête HTTP pour récupérer les détails du jeu en utilisant l'ID du jeu
    final response = await http.get(Uri.parse('https://store.steampowered.com/api/appdetails?appids=$gameId'));

    // Si la réponse est OK, on récupère les données JSON et on les transforme en objet GameDetails
    if (response.statusCode == 200) {

      final Map<String, dynamic> gameData = json.decode(response.body);
      final Map<String, dynamic> gameDetailsData = gameData['$gameId']['data'];
      return GameDetails.fromJson(gameDetailsData);

    } else {

      // Si la réponse n'est pas OK, on lève une exception pour signaler l'erreur
      throw Exception('Failed to load game details');

    }

  }

  // Méthode qui récupère les avis d'un jeu en utilisant son ID

  static Future<GameReviews> fetchGameReviews(int gameId) async {
    final response = await http.get(Uri.parse('https://store.steampowered.com/appreviews/$gameId?json=1'));

    if (response.statusCode == 200) {
      final jsonReviews = json.decode(response.body);
      final reviews = (jsonReviews['reviews'] as List)
          .map((r) => Review.fromJson(r))
          .toList();
      return GameReviews(reviews: reviews);
    } else {
      throw Exception('Failed to load game reviews');
    }
  }

  // Méthode qui récupère la liste des jeux les plus joués

  static Future<List<GameStats>> fetchMostPlayedGames() async {
    final response = await http.get(Uri.parse('https://api.steampowered.com/ISteamChartsService/GetMostPlayedGames/v1/?format=json'));
    final games = jsonDecode(response.body)['response']['ranks'];
    if (games != null) {
      final gameStats = List<GameStats>.from(games.map((json) => GameStats.fromJson(json)));
      return gameStats;
    } else {
      throw Exception('Failed to load most played games');
    }
  }

  // Méthode qui récupère les détails d'un jeu en utilisant son ID, mais pour récupérer quelques informations spécifiques
  // On utilise cette méthode dans le main pour afficher les informations de chaque jeu sur la page d'accueil

  static Future<Game> fetchGame(int appId) async {
    final response = await http.get(Uri.parse('https://store.steampowered.com/api/appdetails?appids=$appId'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['$appId'];
      if (data != null && data['data'] != null) {
        final game = Game.fromJson(data['data']);
        return game;
      } else {
        throw Exception('Failed to load game details');
      }
    } else {
      throw Exception('Failed to load game details');
    }
  }

}

class GameDetails {
  final int id;
  final String name;
  final String publisher;
  final String description;
  final String imageUrl;

  GameDetails({
    required this.id,
    required this.name,
    required this.publisher,
    required this.description,
    required this.imageUrl,
  });

  factory GameDetails.fromJson(Map<String, dynamic> json) {
    return GameDetails(
      id: json['steam_appid'],
      name: json['name'],
      publisher: json['publishers'][0],
      description: json['short_description'],
      imageUrl: json['header_image'],
    );
  }
}



class GameReviews {
  final List<Review> reviews;

  GameReviews({required this.reviews});

  factory GameReviews.fromJson(Map<String, dynamic> json) {
    final List<dynamic> jsonReviews = json['reviews'];
    final reviews = jsonReviews.map((r) => Review.fromJson(r)).toList();

    return GameReviews(reviews: reviews);
  }
}


class Review {
  final String author;
  final String review;
  final int score;

  Review({
    required this.author,
    required this.review,
    required this.score,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      author: json['author']['steamid'],
      review: json['review'],
      score: json['votes_up'].clamp(0, 5),
    );
  }
}

class Game {
  final int id;
  final String name;
  final String publisher;
  final String price;


  Game({required this.id, required this.name,required this.publisher, required this.price});

  factory Game.fromJson(Map<String, dynamic> json) {
    if (json['price_overview'] == null && json['is_free']== false) {
      return Game(
        id: json['steam_appid'],
        name: json['name'],
        publisher: json['publishers'][0],
        price: 'erreur',
      );
    }
    return Game(
      id: json['steam_appid'],
      name: json['name'],
      publisher: json['publishers'][0],
      price: json['is_free'] ? '0€' : json['price_overview']['final_formatted'],
    );
  }
}




class GameStats {
  final int id;
  final int rank;

  GameStats({required this.id, required this.rank});

  factory GameStats.fromJson(Map<String, dynamic> json) {
    return GameStats(
      id: json['appid'],
      rank: json['rank'],
    );
  }
}
