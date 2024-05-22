import 'package:flutter/material.dart';
import 'home.dart';
import 'welcome.dart';
import '../utils/database_helper.dart'; // Importez le fichier de base de données
import '../models/user.dart'; // Importez le modèle d'utilisateur

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final DatabaseHelper dbHelper = DatabaseHelper(); // Initialisez la classe DatabaseHelper


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log In'),
        // Ajouter une icône de flèche de retour
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => WelcomeScreen()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'Welcome Back!',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email address',
                hintText: 'name@example.com',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
            controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  value: false, // Mettre à true pour gérer l'état
                  onChanged: (value) {
                    // Gérer le changement d'état
                  },
                ),
                Text('Remember me'),
              ],
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () async {
                // Récupérer les informations de connexion saisies par l'utilisateur
                // Par exemple, vous pouvez utiliser les valeurs des TextFormField
                String email = emailController.text; // Récupérer l'email
                String password = passwordController.text; // Récupérer le mot de passe

                // Vérifier si les informations de connexion sont valides dans la base de données
                bool isValid = await dbHelper.isValidUser(email, password);

                if (isValid) {
                  // Si les informations sont valides, naviguer vers une nouvelle page ou afficher un message de confirmation
                  // Par exemple, naviguer vers la page d'accueil
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                } else {
                  // Sinon, afficher un message d'erreur
                  showDialog(
                    context: context,
                      builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Invalid email or password. Please try again.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Log in'),
            ),
          ],
        ),
      ),
    );
  }
}
