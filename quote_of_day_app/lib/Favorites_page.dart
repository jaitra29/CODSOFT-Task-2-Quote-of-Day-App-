// FavoritesPage.dart

// FavoritesPage.dart

import 'package:flutter/material.dart';

class FavoritesPage extends StatefulWidget {
  final List<String> favoriteQuotes;

  FavoritesPage({required this.favoriteQuotes});

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
        backgroundColor: Colors.orange,
      ),
      body: _buildFavoritesList(),
    );
  }

  Widget _buildFavoritesList() {
    return widget.favoriteQuotes.isEmpty
        ? Center(
            child: Text('No favorite quotes yet.'),
          )
        : ListView.builder(
            itemCount: widget.favoriteQuotes.length,
            itemBuilder: (context, index) {
              final quote = widget.favoriteQuotes[index];
              return ListTile(
                title: Text(
                  quote,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              );
            },
          );
  }
}
