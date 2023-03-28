import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'api.dart';
import 'backend.dart';
import 'globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Details extends StatefulWidget {
  final Game game;

  const Details({required this.game, Key? key}) : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {

  bool isLiked = false;
  bool isWishlisted = false;


  // Fonction qui retourne la clé associée à la valeur "like" pour un jeu donné
  String getLikeKey(int gameId) => 'isLiked_$gameId';


  // Fonction qui retourne la clé associée à la valeur "wishlist" pour un jeu donné
  String getWishlistKey(int gameId) => 'isWishlisted_$gameId';


  // Fonction qui prend un score en entrée
  String scoreToStars(int score) {
    String star = '⭐️'; // caractère Unicode pour l'étoile
    String stars = '';
    for (int i = 0; i < score; i++) {
      stars += star;
    }
    return stars;
  }

  void _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLiked = prefs.getBool(getLikeKey(widget.game.id)) ?? false;
      isWishlisted = prefs.getBool(getWishlistKey(widget.game.id)) ?? false;
    });
  }


  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details du jeu'),
        backgroundColor: const Color(0xFF1A2025),
        actions: <Widget>[
          IconButton(
            icon: isLiked ? SvgPicture.asset("res/images/like_full.svg") : SvgPicture.asset("res/images/like.svg"),
            onPressed: () async {
              setState(() {
                isLiked = !isLiked;
                if (isLiked) {
                  //gameLikeID.add(widget.game.id);
                  gameLikeID[widget.game.id] = widget.game.name;
                } else {
                  gameLikeID.remove(widget.game.id);
                }
              });
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool(getLikeKey(widget.game.id), isLiked);
              Backend.addLike();
            },

          ),
          IconButton(
            icon: isWishlisted ? SvgPicture.asset("res/images/whishlist_full.svg") : SvgPicture.asset("res/images/whishlist.svg"),
            onPressed: () async {
              setState(() {
                isWishlisted = !isWishlisted;
                if (isWishlisted) {
                  //gameWishID.add(widget.game.id);
                  gameWishID[widget.game.id] = widget.game.name;
                } else {
                  gameWishID.remove(widget.game.id);
                }
              });
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool(getWishlistKey(widget.game.id), isWishlisted);
              Backend.addWish();
            },

          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xff1A2025),
        ),
        child: DefaultTabController(
          length: 2,
          child: SingleChildScrollView(
            child: Center(
              child: FutureBuilder<GameDetails>(
                future: Api.fetchGameDetails(widget.game.id),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final gameDetails = snapshot.data!;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(gameDetails.imageUrl),
                        const SizedBox(height: 16),
                        Text(
                          'Nom du jeu: ${widget.game.name}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Nom de l\'éditeur: ${widget.game.publisher}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xff636AF6)),
                          ),
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          child: TabBar(
                            labelColor: Colors.white,
                            indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: const Color(0xff636AF6),
                            ),
                            tabs: const [
                              Tab(
                                text: 'DESCRIPTION',
                              ),
                              Tab(
                                text: 'AVIS',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 400,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: TabBarView(
                              children: [
                                Center(
                                  child: Text(
                                    gameDetails.description,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                FutureBuilder<GameReviews>(
                                  future: Api.fetchGameReviews(widget.game.id),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final gameReviews = snapshot.data!;
                                      return ListView.builder(
                                        padding: const EdgeInsets.only(bottom: 30),
                                        itemCount: gameReviews.reviews.length,
                                        itemBuilder: (context, index) {
                                          final review = gameReviews.reviews[index];
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 8),
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: const Color(0xff1E262C),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${review.author}: ${scoreToStars(review.score)}',
                                                    style: const TextStyle(color: Colors.white),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    review.review,
                                                    maxLines: 3,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );


                                    } else if (snapshot.hasError) {
                                      return Text('Erreur: ${snapshot.error}');
                                    }
                                    // By default, show a loading spinner.
                                    return const CircularProgressIndicator();
                                  },
                                ),

                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text('Erreur: ${snapshot.error}');
                  }
                  // By default, show a loading spinner.
                  return const CircularProgressIndicator();
                },
              ),
            ),
          ),
        ),
      ),

    );
  }
}






