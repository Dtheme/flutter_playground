class PodcastModel {
  final String wrapperType;
  final String kind;
  final int artistId;
  final int collectionId;
  final int trackId;
  final String artistName;
  final String collectionName;
  final String trackName;
  final String collectionCensoredName;
  final String trackCensoredName;
  final String artistViewUrl;
  final String collectionViewUrl;
  final String feedUrl;
  final String trackViewUrl;
  final String artworkUrl30;
  final String artworkUrl60;
  final String artworkUrl100;
  final double collectionPrice;  // 修改为 double
  final double trackPrice;       // 修改为 double
  final int collectionHdPrice;
  final String releaseDate;
  final String collectionExplicitness;
  final String trackExplicitness;
  final int trackCount;
  final int trackTimeMillis;
  final String country;
  final String currency;
  final String primaryGenreName;
  final String contentAdvisoryRating;
  final String artworkUrl600;
  final List<String> genreIds;
  final List<String> genres;

  PodcastModel({
    required this.wrapperType,
    required this.kind,
    required this.artistId,
    required this.collectionId,
    required this.trackId,
    required this.artistName,
    required this.collectionName,
    required this.trackName,
    required this.collectionCensoredName,
    required this.trackCensoredName,
    required this.artistViewUrl,
    required this.collectionViewUrl,
    required this.feedUrl,
    required this.trackViewUrl,
    required this.artworkUrl30,
    required this.artworkUrl60,
    required this.artworkUrl100,
    required this.collectionPrice,
    required this.trackPrice,
    required this.collectionHdPrice,
    required this.releaseDate,
    required this.collectionExplicitness,
    required this.trackExplicitness,
    required this.trackCount,
    required this.trackTimeMillis,
    required this.country,
    required this.currency,
    required this.primaryGenreName,
    required this.contentAdvisoryRating,
    required this.artworkUrl600,
    required this.genreIds,
    required this.genres,
  });

  // 从 JSON 创建 PodcastModel 实例
  factory PodcastModel.fromJson(Map<String, dynamic> json) {
    return PodcastModel(
      wrapperType: json['wrapperType'] ?? '未知',
      kind: json['kind'] ?? '未知',
      artistId: json['artistId'] ?? 0,
      collectionId: json['collectionId'] ?? 0,
      trackId: json['trackId'] ?? 0,
      artistName: json['artistName'] ?? '未知',
      collectionName: json['collectionName'] ?? '未知',
      trackName: json['trackName'] ?? '未知',
      collectionCensoredName: json['collectionCensoredName'] ?? '未知',
      trackCensoredName: json['trackCensoredName'] ?? '未知',
      artistViewUrl: json['artistViewUrl'] ?? '',
      collectionViewUrl: json['collectionViewUrl'] ?? '',
      feedUrl: json['feedUrl'] ?? '',
      trackViewUrl: json['trackViewUrl'] ?? '',
      artworkUrl30: json['artworkUrl30'] ?? '',
      artworkUrl60: json['artworkUrl60'] ?? '',
      artworkUrl100: json['artworkUrl100'] ?? '',
      collectionPrice: (json['collectionPrice'] is int)
          ? json['collectionPrice'].toDouble()
          : json['collectionPrice'] ?? 0.0, // 确保是 double 类型
      trackPrice: (json['trackPrice'] is int)
          ? json['trackPrice'].toDouble()
          : json['trackPrice'] ?? 0.0,       // 确保是 double 类型
      collectionHdPrice: json['collectionHdPrice'] ?? 0,
      releaseDate: json['releaseDate'] ?? '',
      collectionExplicitness: json['collectionExplicitness'] ?? 'notExplicit',
      trackExplicitness: json['trackExplicitness'] ?? 'cleaned',
      trackCount: json['trackCount'] ?? 0,
      trackTimeMillis: json['trackTimeMillis'] ?? 0,
      country: json['country'] ?? '未知',
      currency: json['currency'] ?? 'USD',
      primaryGenreName: json['primaryGenreName'] ?? '未知',
      contentAdvisoryRating: json['contentAdvisoryRating'] ?? 'Clean',
      artworkUrl600: json['artworkUrl600'] ?? '',
      genreIds: List<String>.from(json['genreIds'] ?? []),
      genres: List<String>.from(json['genres'] ?? []),
    );
  }

  // 将 PodcastModel 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'wrapperType': wrapperType,
      'kind': kind,
      'artistId': artistId,
      'collectionId': collectionId,
      'trackId': trackId,
      'artistName': artistName,
      'collectionName': collectionName,
      'trackName': trackName,
      'collectionCensoredName': collectionCensoredName,
      'trackCensoredName': trackCensoredName,
      'artistViewUrl': artistViewUrl,
      'collectionViewUrl': collectionViewUrl,
      'feedUrl': feedUrl,
      'trackViewUrl': trackViewUrl,
      'artworkUrl30': artworkUrl30,
      'artworkUrl60': artworkUrl60,
      'artworkUrl100': artworkUrl100,
      'collectionPrice': collectionPrice,
      'trackPrice': trackPrice,
      'collectionHdPrice': collectionHdPrice,
      'releaseDate': releaseDate,
      'collectionExplicitness': collectionExplicitness,
      'trackExplicitness': trackExplicitness,
      'trackCount': trackCount,
      'trackTimeMillis': trackTimeMillis,
      'country': country,
      'currency': currency,
      'primaryGenreName': primaryGenreName,
      'contentAdvisoryRating': contentAdvisoryRating,
      'artworkUrl600': artworkUrl600,
      'genreIds': genreIds,
      'genres': genres,
    };
  }
}

class PodcastEpisode {
  final String title;
  final String description;
  final String audioUrl;
  final String pubDate;
  final String duration;
  final String imageUrl;

  PodcastEpisode({
    required this.title,
    required this.description,
    required this.audioUrl,
    required this.pubDate,
    required this.duration,
    required this.imageUrl,
  });

  factory PodcastEpisode.fromJson(Map<String, dynamic> json) {
    return PodcastEpisode(
      title: json['title'] ?? '无标题',
      description: json['description'] ?? '无描述',
      audioUrl: json['enclosure']?['@attributes']?['url'] ?? '',
      pubDate: json['pubDate'] ?? '',
      duration: json['itunes:duration'] ?? '',
      imageUrl: json['itunes:image']?['@attributes']?['href'] ?? '',
    );
  }
}
