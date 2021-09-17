import 'package:flutter/material.dart';
import 'package:webfeed/domain/rss_feed.dart';
import 'package:webfeed/domain/rss_item.dart';
import 'package:http/http.dart' as http;

const podcastUrl = 'https://itsallwidgets.com/podcast/feed';

class Podcast extends ChangeNotifier {
  RssFeed? _feed;
  late RssItem _rssItem;

  RssFeed? get feed => _feed;

  void parse() async {
    var res = await http.get(Uri.parse(podcastUrl));
    _feed = RssFeed.parse(res.body);
    notifyListeners();
  }

  RssItem get rssItem => _rssItem;

  set rssItem(RssItem rssItem) {
    _rssItem = rssItem;
  }
}
