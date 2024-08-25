

class RadioStation {
  final String uuid;
  final String? homepage;
  final String name;
  final String? favicon;
  final List<String> tags;
  final String country;
  final String streamUrl;

  RadioStation(this.uuid, this.homepage, this.name, this.favicon, this.tags,
      this.country, this.streamUrl);

  factory RadioStation.fromJson(Map<String, dynamic> json) {
    return RadioStation(
      json['stationuuid'],
      json['homepage'],
      json['name'],
      json['favicon'],
      (json['tags'] as String).isNotEmpty ? json['tags'].toString().split(',') : [],
      json['country'],
      json['url_resolved'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stationuuid': uuid,
      'homepage': homepage,
      'name': name,
      'favicon': favicon,
      'tags': tags.join(','),
      'country': country,
      'url_resolved': streamUrl,
    };
  }

}
