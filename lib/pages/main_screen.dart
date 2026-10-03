import 'package:flutter/material.dart';
import 'package:movie_wave/pages/home_page.dart';
import 'package:movie_wave/pages/now_playing_page.dart';
import 'package:movie_wave/pages/search_page.dart';
import 'package:movie_wave/pages/tv_shows_page.dart';

class MainScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _pages = [HomePage(), NowPlaying(), TvShowsPage(), SearchPage()];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle),
            label: "Play Now",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie_creation_outlined),
            label: "TV Shows",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
        ],
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.red,
        selectedLabelStyle: TextStyle(fontSize: 12),
      ),
      body: _pages[_selectedIndex],
    );
  }
}
