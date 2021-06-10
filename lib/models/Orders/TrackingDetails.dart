

class TrackingDetails {
  List<TrackItem> trackItems;

  String error,success;

  TrackingDetails({this.trackItems});

  TrackingDetails.withError(String errorMessage) {
    error = errorMessage;
  }
  TrackingDetails.withSuccess(String successMessage) {
    success = successMessage;
  }

  TrackingDetails.fromJson(Map<String,dynamic> json) {
    if (json["data"]["stages"] != null) {
      trackItems= new List<TrackItem>();
      json["data"]["stages"] .forEach((v) {
        trackItems.add(new TrackItem.fromJson(v));
      });
    }
  }

}

class TrackItem{
  String title,description,image,status,date;
  bool expanded;

  TrackItem({this.title,this.description,this.image,this.status,this.expanded,this.date});

  factory TrackItem.fromJson(Map<String,dynamic> json) {
    print("TRACK JSON: ${json.toString()}");
    return TrackItem(
        status:json["active"].toString(),
        title: json["title"],
        description: json["description"],
        image: json["image"],
        date: json["date"],
        expanded: false
    );
  }



}

