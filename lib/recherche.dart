import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'details.dart';
import 'globals.dart';

class Recherche extends StatefulWidget {
  String search;

  Recherche({required this.search});

  @override
  State<Recherche> createState() => _RechercheState();
}

class _RechercheState extends State<Recherche> {

  @override
  void initState() {
    super.initState();

    // On filtre les jeux en fonction de l'input de recherche
    final filteredGames = widget.search.isNotEmpty
        ? gameNames.where((name) => name.toLowerCase().contains(widget.search.toLowerCase())).toList()
        : [];

    // On récupère les ID des jeux filtrés et on les ajoute à la liste gamesList2
    if (filteredGames.isNotEmpty) {
      for (var i = 0; i < filteredGames.length; i++) {
        final filteredGameName = filteredGames[i];
        final game = gamesList.firstWhere((game) => game.name == filteredGameName);
        gamesList2.add(game);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _search =
    TextEditingController(text: widget.search);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A2025),
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 14.0),
              child: IconButton(
                icon: SvgPicture.asset(
                  'res/images/close.svg',
                  height: 16,
                  width: 16,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    gamesList2.clear(); // on vide la liste gamesList2
                  });
                  Navigator.pop(context); // on navigue vers la page précédente
                },
              ),
            ),
            const Text('Recherche'),
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xff1A2025),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _search,
                enabled: false, // désactive la modification
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    color: Color(0xFF636AF6),
                    onPressed: () {},
                  ),
                  labelText: '',
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  labelStyle: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Calibri',
                      fontSize: 13),
                  filled: true,
                  fillColor: Color(0xFF1E262C),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: gamesList2.length,
                  itemBuilder: (context, index) {
                    final gameName = gamesList2[index];
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
                                    gameName.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    gameName.publisher,
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
                                  MaterialPageRoute(builder: (context) => Details(game: gameName)),
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
      ),
    );
  }
}
