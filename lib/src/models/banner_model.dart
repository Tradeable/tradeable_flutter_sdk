class BannerModel {
  final String? imageUrl;
  final String? ctaUri;

  BannerModel({
    this.imageUrl,
    this.ctaUri,
  });

  factory BannerModel.fromJson(dynamic json) {
    if (json is String) {
      return BannerModel(imageUrl: json);
    }

    if (json is Map<String, dynamic>) {
      return BannerModel(
        imageUrl: json['image_url'] as String?,
        ctaUri: json['cta_uri'] as String?,
      );
    }

    return BannerModel();
  }
}
