import 'package:flutter/material.dart';

class NowPlaying extends StatefulWidget {
  const new({super.key});

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Now Playing")));
  }
}
