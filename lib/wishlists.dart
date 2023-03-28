import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'accueil.dart';
import 'details.dart';
import 'globals.dart';

class Wishlists extends StatefulWidget {
  const Wishlists({Key? key}) : super(key: key);

  @override
  State<Wishlists> createState() => _WishlistsState();
}

class _WishlistsState extends State<Wishlists> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A2025),
        automaticallyImplyLeading: false, // ne pas montrer la flèche de retour
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right:14.0),
              child: IconButton(
                icon: SvgPicture.asset(
                  'res/images/close.svg',
                  height: 16,
                  width: 16,
                  color: Colors.white,
                ), onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Accueil()),
                );
              },
              ),
            ),
            const Text('Ma liste de souhaits'),
          ],
        ),

      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xff1A2025),
        ),
        child: gameWishID.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'res/images/empty_whishlist.svg',
                height: 94,
                width: 94,
                color: Colors.white,
              ),
              const SizedBox(height: 47),
              Container(
                height: 80,
                width: 280,
                child: const Text(
                  'Vous n’avez encore pas liké de contenu. Cliquez sur l\'étoile pour en rajouter.',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        )
            :ListView.builder(
          itemCount: gameWishID.length,
          itemBuilder: (context, index) {
            final gameId = gameWishID.keys.toList()[index];
            final game = gamesList.firstWhere((game) => game.id == gameId);
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
                            game.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            game.publisher,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 9),
                          Text(
                            'Prix: ${game.price}',
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
                          MaterialPageRoute(builder: (context) => Details(game: game)),
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
    );
  }
}
