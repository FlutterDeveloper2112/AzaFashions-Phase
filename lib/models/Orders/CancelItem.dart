
class CancelItem{

  String reasonId;
  String reason;
  String comments;

  CancelItem({this.reasonId, this.reason, this.comments});


  CancelItem.fromJson(Map<String,dynamic> json){
    reasonId = json['reason_id'];
    reason  = json['reason'];
    comments  = json['comments'];
  }

  CancelItem.toJson(){
    Map<String,dynamic> jsonData = {};
    jsonData['reason_id'] = reasonId;
    jsonData['reason'] = reason;
    jsonData['comments'] = comments;

  }
}