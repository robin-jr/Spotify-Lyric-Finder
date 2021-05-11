class Lyrics {
  final String query;
  final String url;
  final String lyrics;

  Lyrics(this.query, this.url, this.lyrics);

  Map<String, dynamic> toMap() {
    return {
      'query': query,
      'url': url,
      'lyrics': lyrics,
    };
  }

  @override
  String toString() {
    return 'Lyric{query: $query, url: $url, lyrics: $lyrics}';
  }
}
