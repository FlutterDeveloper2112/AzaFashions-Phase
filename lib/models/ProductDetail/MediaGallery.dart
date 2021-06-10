class MediaGallery{
  String url;
  String mediaType;

  MediaGallery(this.url, this.mediaType);

  MediaGallery.fromJson(Map<String,dynamic> json){
    url = json['url'];
    mediaType = json['media_type'];
  }
}