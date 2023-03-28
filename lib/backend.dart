import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'globals.dart';

class Backend {

  static void addLike() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Convertir les clés int en chaînes de caractères
      Map<String, String> gameLikes = {};
      for (var key in gameLikeID.keys) {
        gameLikes[key.toString()] = gameLikeID[key]!;
      }

      final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
      if (await docRef.get().then((doc) => doc.exists)) {
        // Le document existe déjà, on met à jour les données
        await docRef.update({'liked': gameLikes});
      } else {
        // Le document n'existe pas encore, on le crée avec les données
        await docRef.set({'liked': gameLikes});
      }
    }
  }

  static void addWish() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Convertir les clés int en chaînes de caractères
      Map<String, String> gameWish = {};
      for (var key in gameWishID.keys) {
        gameWish[key.toString()] = gameWishID[key]!;
      }

      final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
      if (await docRef.get().then((doc) => doc.exists)) {
        // Le document existe déjà, on met à jour les données
        await docRef.update({'wishlisted': gameWish});
      } else {
        // Le document n'existe pas encore, on le crée avec les données
        await docRef.set({'wishlisted': gameWish});
      }
    }
  }

  // Fonction qui récupère les "likes" de jeux de l'utilisateur depuis Firestore
  static Future<void> getUsersGameLikes() async {

    // Effacer les données précédentes
    gameLikeID.clear();

    // Récupérer l'utilisateur courant
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {

      // Récupérer les données utilisateur depuis Firestore
      final userData =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      // Convertir les données Firestore en une map
      final Map<String, dynamic> data = userData.data()!;

      // Récupérer les "likes" de jeux de l'utilisateur courant
      final Map<dynamic, dynamic> gameLikes = data['liked'] ?? {};

      // Créer une map avec des clés "int" pour les "likes" de jeux
      final Map<int, String> likes = {};

      for (final key in gameLikes.keys) {

        // Convertir la clé de type "dynamic" en entier
        likes[int.parse(key)] = gameLikes[key];

      }

      // Mettre à jour la map "gameLikeID"
      gameLikeID = likes;
    }
  }

  // Fonction qui récupère les "wishlist" de jeux de l'utilisateur depuis Firestore
  static Future<void> getUsersGameWish() async {

    // Effacer les données précédentes
    gameWishID.clear();

    // Récupérer l'utilisateur courant
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {

      // Récupérer les données utilisateur depuis Firestore
      final userData =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      // Convertir les données Firestore en une map
      final Map<String, dynamic> data = userData.data()!;

      // Récupérer les jeux "wishlistés" de l'utilisateur courant
      final Map<dynamic, dynamic> gameWish = data['wishlisted'] ?? {};

      // Créer une map avec des clés "int" pour les jeux "wishlistés"
      final Map<int, String> wish = {};

      for (final key in gameWish.keys) {

        // Convertir la clé de type "dynamic" en entier
        wish[int.parse(key)] = gameWish[key];

      }

      // Mettre à jour la map "gameWishID"
      gameWishID = wish;
    }
  }
}