
class CancelReasonsListing {
  List<CancelReasons> cancelReasons;

  String error,success;

  CancelReasonsListing({this.cancelReasons});

  CancelReasonsListing.withError(String errorMessage) {
    error = errorMessage;
  }
  CancelReasonsListing.withSuccess(String successMessage) {
    success = successMessage;
  }

  CancelReasonsListing.fromJson(Map<String,dynamic> json) {
    if (json["data"]["list"] != null) {
      cancelReasons= new List<CancelReasons>();
      json["data"]["list"] .forEach((v) {
        cancelReasons.add(new CancelReasons.fromJson(v));
      });
    }
  }

}
class CancelReasons{
  int id;
  String reason,comments="";
  bool status;
  int qty=0;

  CancelReasons({this.id,this.reason,this.status,this.comments,this.qty});

  factory CancelReasons.fromJson(Map<String,dynamic> json) {
    return CancelReasons(
      id:json["reason_id"],
      reason: json["reason"],
      status: false,
      comments:"",
      qty:0
    );
  }



}

