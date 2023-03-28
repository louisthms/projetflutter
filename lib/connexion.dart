import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'inscription.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'accueil.dart';
import 'backend.dart';


class Connexion extends StatefulWidget {
  const Connexion({super.key});

  @override
  State<Connexion> createState() => _ConnexionState();
}

class _ConnexionState extends State<Connexion> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  // Fonction qui s'utilise lorsqu'on clique sur le bouton de connexion
  Future<void> _signIn() async {
    try {

      // Vérifier que les champs email et mot de passe ne sont pas vides
      if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
        throw 'Veuillez remplir tous les champs.';
      }

      // Connecter l'utilisateur avec Firebase Auth
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Rediriger l'utilisateur vers la page d'accueil
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Accueil()),
      );

      await Backend.getUsersGameLikes();
      await Backend.getUsersGameWish();

      await SharedPreferences.getInstance().then((prefs) {
        prefs.clear();
      });

    } on FirebaseAuthException catch (e) {

      // Afficher une erreur en cas d'échec de la connexion
      String errorMessage = 'Une erreur s\'est produite lors de la connexion.';

      if (e.code == 'user-not-found') {

        errorMessage = 'Aucun utilisateur ne correspond à cet e-mail.';

      } else if (e.code == 'wrong-password') {

        errorMessage = 'Mot de passe incorrect.';

      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );
    }
    catch (e) {

      // Afficher une erreur en cas d'échec de la connexion
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xff1A2025),
          image: DecorationImage(
            image: AssetImage("res/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center (
          child : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Bienvenue !',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 16),

              Container(
                height:80,
                width: 200,
                child: const Text(
                  'Veuillez vous connecter ou créer un nouveau compte pour utiliser l\'application.',
                  style: TextStyle(
                    fontSize: 15.7,
                    color: Colors.white,
                  ),
                  maxLines: 3,
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 25),
              SizedBox(
                width: 350,
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    label: Center(
                      child: Text("E-mail"),
                    ),
                    labelStyle: TextStyle(color: Color(0xFFEDF0F3)),
                    enabledBorder: InputBorder.none,

                    filled: true,
                    fillColor: Color(0xFF1E262C),
                  ),
                  style: TextStyle(color: Color(0xFFEDF0F3)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: 350,
                child: TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    label: Center(
                      child: Text("Mot de passe"),
                    ),
                    labelStyle: TextStyle(color: Color(0xFFEDF0F3)),
                    enabledBorder: InputBorder.none,

                    filled: true,
                    fillColor: Color(0xFF1E262C),
                  ),
                  style: TextStyle(color: Color(0xFFEDF0F3)),
                ),
              ),
              const SizedBox(height: 73),

              ElevatedButton(
                onPressed: _signIn,
                child: Text('Se connecter'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(350, 50),
                  backgroundColor: Color(0xFF636AF6),
                ),
              ),
              const SizedBox(height: 15),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Inscription()),
                  );
                },
                child: Text('Créer un nouveau compte'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),

                  ),
                  minimumSize: Size(350, 50),
                  side: BorderSide(width: 2, color: Color(0xff636AF6)),
                  backgroundColor: Colors.transparent,

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
