// QuotePage.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:share/share.dart';
import 'package:quote_of_day_app/Favorites_page.dart';

class QuotePage extends StatefulWidget {
  @override
  _QuotePageState createState() => _QuotePageState();
}

class _QuotePageState extends State<QuotePage> {
  String currentQuote = "Click to get a new inspiring quote";
  String authorName = "";
  String authorImageUrl = "";

  List<String> favoriteQuotes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quote of Day App'),
        backgroundColor: const Color(0xFFFFA732),
      ),
      body: Stack(
        children: [
          authorImageUrl.isNotEmpty
              ? Image.network(
                  authorImageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                )
              : Container(), // Display an empty container if there's no image

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7), // Dark background
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Text(
                    currentQuote,
                    style: TextStyle(
                      fontSize: 24,
                      fontStyle: FontStyle.italic,
                      color: Colors.white, // Set text color to white
                      fontWeight: FontWeight.bold, // Make text bold
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20.0),
                _buildCustomButton(
                  label: 'New Quote',
                  onPressed: _getNewQuote,
                  color: Colors.orange,
                ),
                SizedBox(height: 10.0),
                _buildCustomButton(
                  label: 'Add to Favorites',
                  onPressed: _addToFavorites,
                  color: Colors.orange,
                ),
                SizedBox(height: 10.0),
                _buildCustomButton(
                  label: 'View Favorites',
                  onPressed: _navigateToFavoritesPage,
                  color: Colors.orange,
                ),
                SizedBox(height: 10.0),
                _buildCustomButton(
                  label: 'Share Quote',
                  onPressed: _shareQuote,
                  color: Colors.orange,
                ),
                if (authorName.isNotEmpty)
                  Text(
                    'Author: $authorName',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomButton({
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Container(
        width: 120.0, // Set a fixed width for the buttons
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    );
  }

  Future<void> _getNewQuote() async {
    final response = await http.get(Uri.parse('https://favqs.com/api/qotd'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final String quote = data['quote']['body'];
      final String author = data['quote']['author'];

      // Replace 'KBYUrd_DrgnL6GwnJfi4zhLHFmhibGMkOAquuR3DEAc' with your actual Unsplash API key
      final String imageUrl = await _searchImage('KBYUrd_DrgnL6GwnJfi4zhLHFmhibGMkOAquuR3DEAc', author);

      setState(() {
        currentQuote = quote;
        authorName = author;
        authorImageUrl = imageUrl;
      });
    } else {
      print('Failed to fetch a new quote. Error ${response.statusCode}');
    }
  }

  Future<String> _searchImage(String apiKey, String author) async {
    final unsplashApiUrl =
        'https://api.unsplash.com/search/photos?query=$author&client_id=$apiKey';

    try {
      final response = await http.get(Uri.parse(unsplashApiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'];

        if (results.isNotEmpty) {
          return results[0]['urls']['regular'];
        }
      }
    } catch (e) {
      print('Error searching for image: $e');
    }

    return ''; // Return an empty string if no image is found
  }

  void _shareQuote() {
    if (currentQuote != "Click to get a new inspiring quote") {
      Share.share(currentQuote);
    } else {
      print('Cannot share an empty quote.');
    }
  }

  void _addToFavorites() {
    if (!favoriteQuotes.contains(currentQuote)) {
      setState(() {
        favoriteQuotes.add(currentQuote);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Quote added to Favorites'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Quote is already in Favorites'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _navigateToFavoritesPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FavoritesPage(
          favoriteQuotes: favoriteQuotes,
        ),
      ),
    );
  }
}



