import 'package:flutter/material.dart';
import 'listeville.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<String> searchResults = ['Paris', 'Rio'];

  void search(String query) {
    setState(() {
      if (!searchResults.contains(query)) {
        searchResults.add(query); // Ajouter la ville saisie à la liste des résultats de recherche si elle n'est pas déjà présente
      } else {
        showDuplicateCityDialog(); // Afficher le pop-up si la ville est déjà présente
      }
    });
  }

  void openPage(String query) {
    setState(() {
      if (!searchResults.contains(query)) {
        searchResults.add(query); // Ajouter la ville saisie à la liste des résultats de recherche si elle n'est pas déjà présente
      } else {
        showDuplicateCityDialog(); // Afficher le pop-up si la ville est déjà présente
      }
    });

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WeatherPage(searchResults)), // Utiliser la classe WeatherPage avec les villes sélectionnées
    );
  }

  void showDuplicateCityDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ville déjà ajoutée'),
          content: Text('La ville que vous avez saisie est déjà présente dans la liste.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Fermer le pop-up
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, // Couleur de la flèche
          ),
          title: Text('Ajouter une ville',style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.grey[200],
          elevation: 0,
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                onSubmitted: (query) => openPage(query),
                decoration: InputDecoration(
                  hintText: 'Saisissez le nom d\'une ville',
                  filled: true,
                  fillColor: Colors.grey[300],
                  border: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  prefixIcon: Icon(Icons.search, color: Colors.deepPurpleAccent),
                ),
              ),
            ),
          ],
        )

    );
  }
}
