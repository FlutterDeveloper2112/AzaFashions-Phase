class Measurements {
  int gender;
  FrontMeasurements frontBody;
  BackMeasurements backBody;

  Measurements(this.frontBody, this.backBody);

  Measurements.fromJson(Map<String, dynamic> json) {
    FrontMeasurements.fromJson(json['frontMeasurements']);
    BackMeasurements.fromJson(json['BackMeasurements']);
  }
}

class FrontMeasurements {
  int capSleeveLength;
  int frontNeck;
  int shoulderLength;
  int shortSleeveLength;
  int bust;
  int underBust;
  int sleeveLength;
  int waist;
  int hips;

  FrontMeasurements(
      this.capSleeveLength,
      this.frontNeck,
      this.shoulderLength,
      this.shortSleeveLength,
      this.bust,
      this.underBust,
      this.sleeveLength,
      this.waist,
      this.hips);

  FrontMeasurements.fromJson(Map<String, dynamic> json) {
    json['cap_sleeve_length'] = capSleeveLength;
    json['neck'] = frontNeck;
    json['shoulder_length'] = shoulderLength;
    json['short_sleeve_length'] = shortSleeveLength;
    json['bust'] = bust;
    json['under_bust'] = underBust;
    json['sleeve_length'] = sleeveLength;
    json['waist'] = waist;
    json['hips'] = hips;
  }
}

class BackMeasurements {
  int neck;
  int shoulderApex;
  int backNeckDepth;
  int bicep;
  int elbowRound;
  int kneeLength;
  int bottomLength;

  BackMeasurements(this.neck, this.shoulderApex, this.backNeckDepth, this.bicep,
      this.elbowRound, this.kneeLength, this.bottomLength);

  BackMeasurements.fromJson(Map<String, dynamic> json) {
    json['neck'] = neck;
    json['shoulder_to_apex'] = shoulderApex;
    json['neck_depth'] = backNeckDepth;
    json['bicep'] = bicep;
    json['elbow_round'] = elbowRound;
    json['knee_length'] = kneeLength;
    json['bottom_length'] = bottomLength;
  }
}
