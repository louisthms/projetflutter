import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'connexion.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'globals.dart';

class Inscription extends StatefulWidget {
  const Inscription({super.key});

  @override
  State<Inscription> createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription> {

  final _auth = FirebaseAuth.instance;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool passwordsMatch = false;

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
          child: SingleChildScrollView(
            child : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Inscription',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 16),

                Container(
                  height:80,
                  width: 300,
                  child: const Text(
                    'Veuillez saisir ces différentes informations, afin que vos listes soient sauvegardées.',
                    style: TextStyle(
                      fontSize: 15.7,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 1),

                SizedBox(
                  width: 350,
                  child: TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      label: Center(
                        child: Text("Nom d\'utilisateur"),
                      ),
                      labelStyle: TextStyle(color: Color(0xFFEDF0F3)),
                      enabledBorder: InputBorder.none,

                      filled: true,
                      fillColor: Color(0xFF1E262C),
                    ),
                    style: TextStyle(color: Color(0xFFEDF0F3)),
                  ),
                ),

                const SizedBox(height: 16),

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

                const SizedBox(height: 16),

                SizedBox(
                  width: 350,
                  child: TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      label: const Center(
                        child: Text("Mot de passe"),
                      ),
                      labelStyle: TextStyle(color: Color(0xFFEDF0F3)),
                      enabledBorder: passwordsMatch ? InputBorder.none : OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFFF004F)),
                      ),

                      filled: true,
                      fillColor: Color(0xFF1E262C),
                      suffixIcon: _confirmPasswordController.text.isNotEmpty
                          ? Icon(
                        passwordsMatch ? Icons.check : Icons.error,
                        color: passwordsMatch ? Colors.green : Color(0xFFFF004F),
                      )
                          : null,
                    ),
                    onChanged: (value) {
                      setState(() {
                        passwordsMatch = (_passwordController.text == _confirmPasswordController.text);
                      });
                    },
                    style: TextStyle(color: Color(0xFFEDF0F3)),
                  ),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: 350,
                  child:
                  TextField(
                    controller: _confirmPasswordController,
                    decoration: const InputDecoration(
                      label: Center(
                        child: Text("Vérification du mot de passe"),
                      ),
                      labelStyle: TextStyle(color: Color(0xFFEDF0F3)),
                      enabledBorder: InputBorder.none,

                      filled: true,
                      fillColor: Color(0xFF1E262C),
                    ),
                    style: TextStyle(color: Color(0xFFEDF0F3)),
                    onChanged: (value) {
                      setState(() {
                        passwordsMatch = (_passwordController.text == _confirmPasswordController.text);
                      });
                    },
                  ),
                ),
                const SizedBox(height: 73),

                ElevatedButton(
                  onPressed: () async {
                    try {

                      // Récupérer les valeurs saisies par l'utilisateur
                      final username = _usernameController.text.trim();
                      final email = _emailController.text.trim();
                      final password = _passwordController.text.trim();
                      final confirmPassword = _confirmPasswordController.text.trim();

                      // Vérifier si les champs sont valides
                      if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
                        throw 'Veuillez remplir tous les champs.';
                      }

                      if (password != confirmPassword) {
                        throw 'Les mots de passe ne correspondent pas.';
                      }

                      // Créer le compte Firebase
                      await _auth.createUserWithEmailAndPassword(
                        email: email,
                        password: password,
                      );

                      // Naviguer vers la page de connexion
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Connexion()),
                      );
                      gameLikeID.clear();
                      gameWishID.clear();

                      await SharedPreferences.getInstance().then((prefs) {
                        prefs.clear();
                      });

                    } catch (e) {
                      // Afficher une erreur en cas d'échec de la création du compte
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.toString()),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(350, 50),
                    backgroundColor: const Color(0xFF636AF6),
                  ),
                  child: const Text('S inscrire'),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}




