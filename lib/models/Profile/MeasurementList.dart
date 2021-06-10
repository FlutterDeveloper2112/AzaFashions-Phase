class MeasurementList {
  List<Measurements> measurements;
  String error, success;

  MeasurementList(this.measurements);

  MeasurementList.withError(String errorMessage) {
    error = errorMessage;
  }

  MeasurementList.withSuccess(String successMessage) {
    success = successMessage;
  }

  MeasurementList.fromJson(Map<String, dynamic> json) {
    print("DATA ${json['data']['list']}");
    if (json['data']['list'] != null) {
      measurements = new List<Measurements>();
      json["data"]["list"].forEach((v) {
        measurements.add(new Measurements.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonData = new Map<String, dynamic>();
    jsonData["list"] = measurements;
    return jsonData;
  }
}

class Measurements {
  int id;
  String title;
  String gender;
  MeasurementDetails measurementDetails;
  MaleMeasurement maleMeasurement;
  String error, success;

  Measurements({this.id, this.gender, this.title, this.measurementDetails,this.maleMeasurement});

  Measurements.fromJson(Map<String, dynamic> json) {
    print("FRONT ${json['front']}");
    id = json['id'];
    gender = json['gender'];
    title = json['title'];
    if (gender == "Male") {
      maleMeasurement = MaleMeasurement.fromJson(json['measurement']);
    } else {
      measurementDetails = MeasurementDetails.fromJson(json['measurement']);
    }

    // frontBody = FrontMeasurements.fromJson(json['front']);
    // if(gender=="Female"){
    //   backBody = BackMeasurements.fromJson(json['back']);
    // }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonData = new Map<String, dynamic>();
    jsonData["id"] = id;
    jsonData["gender"] = gender;
    jsonData['title'] = "title";
    if(gender=="Male"){
      jsonData['measurement'] = maleMeasurement;
    }
    else{
      jsonData['measurement'] = measurementDetails;
    }
    // jsonData["front"] = frontBody;
    // jsonData["back"] = backBody;
    return jsonData;
  }

  Measurements.withError(String errorMessage) {
    error = errorMessage;
  }

  Measurements.withSuccess(String successMessage) {
    success = successMessage;
  }
}

class MeasurementDetails {
  MaleMeasurement measurement;
  FrontMeasurements frontBody;
  BackMeasurements backBody;
  String error, success;

  MeasurementDetails({this.frontBody, this.backBody});

  MeasurementDetails.fromJson(Map<String, dynamic> json) {
    frontBody = FrontMeasurements.fromJson(json['front']);
    backBody = BackMeasurements.fromJson(json['back']);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonData = new Map<String, dynamic>();
    jsonData["front"] = frontBody;
    jsonData["back"] = backBody;
    return jsonData;
  }

  MeasurementDetails.withError(String errorMessage) {
    error = errorMessage;
  }

  MeasurementDetails.withSuccess(String successMessage) {
    success = successMessage;
  }
}

class FrontMeasurements {
  String capSleeveLength;
  String frontNeck;
  String shoulderLength;
  String shortSleeveLength;
  String bust;
  String underBust;
  String sleeveLength;
  String waist;
  String hips;

  FrontMeasurements(
      {this.capSleeveLength,
        this.frontNeck,
        this.shoulderLength,
        this.shortSleeveLength,
        this.bust,
        this.underBust,
        this.sleeveLength,
        this.waist,
        this.hips});

  FrontMeasurements.fromJson(Map<String, dynamic> json) {

    capSleeveLength = json['cap_sleeve_length'];
    frontNeck = json['neck'];
    shoulderLength = json['shoulder_length'];
    shortSleeveLength = json['short_sleeve_length'];
    bust = json['bust'];
    underBust = json['under_bust'];
    sleeveLength = json['sleeve_length'];
    waist = json['waist'];
    hips = json['hips'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonData = new Map<String, dynamic>();
    jsonData["cap_sleeve_length"] = capSleeveLength;
    jsonData["neck"] = frontNeck;
    jsonData["shoulder_length"] = shoulderLength;
    jsonData["short_sleeve_length"] = shortSleeveLength;
    jsonData["bust"] = bust;
    jsonData["under_bust"] = underBust;
    jsonData["sleeve_length"] = sleeveLength;
    jsonData["waist"] = waist;
    jsonData["hips"] = hips;

    return jsonData;
  }
}

class BackMeasurements {
  String neck;
  String shoulderApex;
  String backNeckDepth;
  String bicep;
  String elbowRound;
  String kneeLength;
  String bottomLength;

  BackMeasurements(
      {this.neck,
        this.shoulderApex,
        this.backNeckDepth,
        this.bicep,
        this.elbowRound,
        this.kneeLength,
        this.bottomLength});

  BackMeasurements.fromJson(Map<String, dynamic> json) {
    print("BACK $json");
    neck = json['neck'];
    shoulderApex = json['shoulder_to_apex'];
    backNeckDepth = json['neck_depth'];
    bicep = json['bicep'];
    elbowRound = json['elbow_round'];
    kneeLength = json['knee_length'];
    bottomLength = json['bottom_length'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonData = new Map<String, dynamic>();
    jsonData["neck"] = neck;
    jsonData["shoulder_to_apex"] = shoulderApex;
    jsonData["neck_depth"] = backNeckDepth;
    jsonData["bicep"] = bicep;
    jsonData["elbow_round"] = elbowRound;
    jsonData["knee_length"] = kneeLength;
    jsonData["bottom_length"] = bottomLength;

    return jsonData;
  }
}

class MaleMeasurement {
  String chest;
  String waist;
  String hips;
  String shoulderLength;

  MaleMeasurement({this.chest, this.waist, this.hips, this.shoulderLength});

  MaleMeasurement.fromJson(Map<String, dynamic> json) {
    chest = json['chest'];
    waist = json['waist'];
    hips = json['hips'];
    shoulderLength = json['shoulder_length'];
  }

  MaleMeasurement.toJson() {
    Map<String, dynamic> jsonData = new Map<String, dynamic>();
    jsonData["chest"] = chest;
    jsonData["shoulder_length"] = shoulderLength;
    jsonData["waist"] = waist;
    jsonData["hips"] = hips;
  }
}
