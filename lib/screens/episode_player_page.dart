import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/models/podcast.dart';
import 'package:untitled/utils/player_manager.dart';
import 'package:webfeed/domain/rss_item.dart';

class EpisodePlayerPage extends StatefulWidget {
  const EpisodePlayerPage({Key? key}) : super(key: key);

  @override
  _EpisodePlayerPageState createState() => _EpisodePlayerPageState();
}

class _EpisodePlayerPageState extends State<EpisodePlayerPage>
    with SingleTickerProviderStateMixin {
  late PlayerManager _playerManager;
  late AnimationController _animationController;
  late RssItem _selectedItem;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
  }

  @override
  void dispose() {
    super.dispose();
    _playerManager.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _selectedItem = Provider.of<Podcast>(context).rssItem;
    _playerManager =
        PlayerManager(url: _selectedItem.enclosure!.url.toString());
    double screenHeight = MediaQuery.of(context).size.height;
    return Dismissible(
      key: Key('key'),
      direction: DismissDirection.down,
      onDismissed: (_) => Navigator.pop(context),
      child: Scaffold(
          appBar: AppBar(
            title: Text(_selectedItem.title.toString()),
            centerTitle: true,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 1,
                child: Image.asset(
                  'assets/images/podcast.jpg',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                    height: 100,
                    child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Text(_selectedItem.description!.trim()))),
              ),
              SizedBox(
                height: 112,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: ValueListenableBuilder<ProgressBarState>(
                          valueListenable: _playerManager.progressNotifier,
                          builder: (_, value, __) {
                            return ProgressBar(
                              progress: value.current,
                              total: value.total,
                              buffered: value.buffered,
                              onSeek: (position) {
                                _playerManager.seek(position);
                              },
                            );
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: ValueListenableBuilder<ButtonState>(
                          valueListenable: _playerManager.buttonNotifier,
                          builder: (_, value, __) {
                            if (value == ButtonState.paused ||
                                value == ButtonState.playing) {
                              return IconButton(
                                  onPressed: () {
                                    if (value == ButtonState.paused) {
                                      _playerManager.play();
                                      _animationController.forward();
                                    } else {
                                      _playerManager.pause();
                                      _animationController.reverse();
                                    }
                                  },
                                  iconSize: 50,
                                  icon: AnimatedIcon(
                                      icon: AnimatedIcons.play_pause,
                                      progress: _animationController));
                            }
                            return Container(
                              margin: EdgeInsets.all(8.0),
                              width: 50,
                              height: 50,
                              child: CircularProgressIndicator(),
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
