import 'package:flutter/material.dart';
import 'login.dart';
import 'welcome.dart';
import '../utils/database_helper.dart'; // Importez le fichier de base de données
import '../models/user.dart'; // Importez le modèle d'utilisateur


class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        // Ajouter une icône de flèche de retour
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => WelcomeScreen()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Create new account',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: fullNameController,
              decoration: const InputDecoration(
                labelText: 'Full name',
                hintText: 'John Doe',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email address',
                hintText: 'name@example.com',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Create Password',
                hintText: 'Enter your password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () async {
                // Récupérer les informations d'inscription saisies par l'utilisateur
                // Par exemple, vous pouvez utiliser les valeurs des TextFormField
                String fullName = fullNameController.text; // Récupérer le nom complet
                String email = emailController.text; // Récupérer l'email
                String password = passwordController.text; // Récupérer le mot de passe

                // Enregistrer les nouvelles informations d'utilisateur dans la base de données
                // Par exemple, utiliser la méthode insertUser de la classe DatabaseHelper
                int userId = await dbHelper.insertUser(User(username: fullName, email: email, password: password));

                // Naviguer vers une nouvelle page ou afficher un message de confirmation
                // Par exemple, afficher un message de succès d'inscription
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Success'),
                      content: Text('Your account has been created successfully.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => LogInPage()),
                            );;
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
