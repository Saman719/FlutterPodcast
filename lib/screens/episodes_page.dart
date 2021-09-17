import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/models/podcast.dart';
import 'package:untitled/screens/episode_player_page.dart';

class EpisodesPage extends StatelessWidget {
  const EpisodesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Podcast'),
        centerTitle: true,
      ),
      body: Consumer<Podcast>(
        builder: (_, podcast, __) {
          return podcast.feed != null
              ? EpisodesListView()
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class EpisodesListView extends StatelessWidget {
  final ScrollController _controller = ScrollController();

  void _openEpisodePlayerPage(BuildContext context) {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return EpisodePlayerPage();
      },
      transitionDuration: Duration(milliseconds: 300),
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0))
              .animate(anim1),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final podcast = Provider.of<Podcast>(context);
    return ListView(
      children: podcast.feed!.items!.map((item) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: Image.asset('assets/images/podcast.jpg'),
            title: Text(item.title.toString()),
            subtitle: Text(
              item.itunes!.summary.toString(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              podcast.rssItem = item;
              _openEpisodePlayerPage(context);
            },
          ),
        );
      }).toList().reversed.toList(),
    );
  }
}
