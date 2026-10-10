import 'package:flutter/material.dart';
import 'package:movie_wave/models/tv_show_model.dart';
import 'package:movie_wave/services/tv_show_service.dart';
import 'package:movie_wave/widgets/tv_show_card.dart';

class TvShowsPage extends StatefulWidget {
  const new({super.key});

  @override
  State<TvShowsPage> createState() => _TvShowsPageState();
}

class _TvShowsPageState extends State<TvShowsPage> {
  List<TvShow> _tvShows = [];
  bool _isLoading = false;
  bool _hasMore = true;
  String _error = '';
  int _currentPage = 1;
  @override
  void initState() {
    super.initState();
    _fetchTvShows();
  }

  //method to fetch populer tv shows

  Future<void> _fetchTvShows() async {
    if (_isLoading || !_hasMore) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      final newTvShow = await TvShowService().getPopulerTvShow(
        page: _currentPage,
      );
      setState(() {
        if (newTvShow.isEmpty) {
          _hasMore = false;
        } else {
          _tvShows.addAll(newTvShow);
          _currentPage++;
        }
      });
    } catch (error) {
      print("error loading tv show $error");
      _error = "Error loading tv show";
    } finally {
      _isLoading = false;
    }
  }
  //method to fetch tv shows
  /*Future<void> _fetchTvShows() async {
    try {
      final tvShow = await TvShowService().getTVShows();
      print(tvShow.length);
      setState(() {
        _tvShows = tvShow;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        _error = "Error loading tv show";
      });
      print("error fetching tvshow $error");
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("TV Shows")),
      body: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: _error.isNotEmpty
            ? Text(_error)
            : NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification notification) {
                  if (!_isLoading &&
                      notification.metrics.pixels ==
                          notification.metrics.maxScrollExtent) {
                    _fetchTvShows();
                  }
                  return true;
                },
                child: SingleChildScrollView(
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: _tvShows.length + (_isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _tvShows.length) {
                        return const Center(child: const CircularProgressIndicator());
                      }
                      return TvShowCard(tvShow: _tvShows[index]);
                    },
                  ),
                ),
              ),
      ),
    );
  }
}
