import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'recherche.dart';
import 'wishlists.dart';
import 'connexion.dart';
import 'details.dart';
import 'likes.dart';
import 'globals.dart';

class Accueil extends StatefulWidget {

  Accueil({Key? key}) : super(key: key);

  @override
  State<Accueil> createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {

  final TextEditingController _recherche = TextEditingController();

  // Fonction qui s'utilise lorsqu'on clique sur le bouton de déconnexion
  void _handleLogout() async {

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {

      // Convertir les clés int en chaînes de caractères
      Map<String, String> gameLikes = {};
      for (var key in gameLikeID.keys) {
        gameLikes[key.toString()] = gameLikeID[key]!;
      }

      // Convertir les clés int en chaînes de caractères
      Map<String, String> gameWish = {};
      for (var key in gameWishID.keys) {
        gameWish[key.toString()] = gameWishID[key]!;
      }

      final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

      if (await docRef.get().then((doc) => doc.exists)) {

        // Le document existe déjà, on met à jour les données
        await docRef.update({'liked': gameLikes, 'wishlisted': gameWish});

      } else {

        // Le document n'existe pas encore, on le crée avec les données
        await docRef.set({'liked': gameLikes, 'wishlisted': gameWish});
      }

    }

    // Déconnecter l'utilisateur
    await FirebaseAuth.instance.signOut();

    // Naviguer vers la page de connexion
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const Connexion()),
            (Route<dynamic> route) => false);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueil'),
        backgroundColor: const Color(0xFF1A2025),
        automaticallyImplyLeading: false, // ne pas montrer la flèche de retour
        actions: <Widget>[
          IconButton(
            icon: SvgPicture.asset("res/images/like.svg"),
            onPressed:(){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Likes()),
              );
            },
          ),
          IconButton(
            icon: SvgPicture.asset("res/images/whishlist.svg"),
            onPressed:(){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Wishlists()),
              );
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFF1A2025),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: TextField(
                controller: _recherche,
                style: const TextStyle(color: Color(0xffEDF0F3)),
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    color: const Color(0xFF636AF6),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Recherche(
                            search: _recherche.text)),
                      );
                    },
                  ),
                  labelText: 'Rechercher un jeu...',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  labelStyle: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Calibri',
                      fontSize: 13
                  ),
                  filled: true,
                  fillColor: const Color(0xFF1E262C),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),
            Expanded(
              child:
              ListView.builder(
                itemCount: gamesList.length,
                itemBuilder: (context, index) {
                  final gameName = gamesList[index];
                  if(index==0) {
                    return Stack(
                      children: [
                        SizedBox(
                          height: 200,
                          width: double.infinity,
                          child: Image.asset(
                            'res/images/affiche.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          left: 16,
                          bottom: 8,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF636AF6),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Details(game: gamesList[index]),
                                  ),
                                );
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                child: Text(
                                  'En savoir plus',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      image: const DecorationImage(
                        image: AssetImage("res/images/game.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${gameName.name}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${gameName.publisher}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 9),
                                Text(
                                  'Prix: ${gameName.price}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF636AF6),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          margin: const EdgeInsets.only(right: 8),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Details(game: gamesList[index])),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 14,
                              ),
                              child: Text(
                                'En savoir plus',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleLogout,
        tooltip: 'Déconnexion',
        backgroundColor: const Color(0xFF1A2025),
        shape: const CircleBorder(
          side: BorderSide(
            color: Colors.white,
            width: 3,
          ),
        ),

        child: const Icon(Icons.logout),
      ),

    );
  }
}






