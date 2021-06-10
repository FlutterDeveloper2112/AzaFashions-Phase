
class CustomizationModelWomen {
  String name;
  String shoulderLength,
      armHole,
      bust,
      waist,
      hips,
      sleeveLength,
      biceps,
      yourHeight,
      frontNeckDepth,
      backNeckDepth,
      kurtaLength,
      bottomLength;

  String type;
  String category;
  String comments;
  int agree;

  CustomizationModelWomen(
      {this.type,
        this.category,
        this.shoulderLength,
        this.armHole,
        this.bust,
        this.waist,
        this.hips,
        this.sleeveLength,
        this.biceps,
        this.yourHeight,
        this.frontNeckDepth,
        this.backNeckDepth,
        this.kurtaLength,
        this.bottomLength,
        this.comments,
        this.agree});

  CustomizationModelWomen.fromJson(Map<String, dynamic> json) {
    type = json['measurement_unit'];
    shoulderLength = json['shoulder_length'];
    armHole = json['arm_hole'];
    bust = json['bust'];
    waist = json['waist'];
    hips = json['hips'];
    sleeveLength = json['sleeve_length'];
    biceps = json['bicep'];
    yourHeight = json['height'];
    frontNeckDepth = json['front_neck_depth'];
    backNeckDepth = json['back_neck_depth'];
    kurtaLength = json['kurta_length'];
    bottomLength = json['bottom_length'];
    comments = json['comment'];
    agree = json['need_help'];
  }
}

class CustomizationModelMen {
  String type;
  String category;
  String shoulder,
      chest,
      frontShoulderToWaist,
      waist,
      armLength,
      hip,
      crotchDepth,
      waistToKnee,
      kneeLine,
      neckCircumference,
      napeToWaist,
      backWidth,
      topArmCircumference,
      waistToFloor;
  String comment;
  int needHelp;

  CustomizationModelMen(
      {this.type,
        this.category,
        this.shoulder,
        this.chest,
        this.frontShoulderToWaist,
        this.waist,
        this.armLength,
        this.hip,
        this.crotchDepth,
        this.waistToKnee,
        this.kneeLine,
        this.neckCircumference,
        this.napeToWaist,
        this.backWidth,
        this.topArmCircumference,
        this.waistToFloor,
        this.comment,
        this.needHelp});

  CustomizationModelMen.fromJson(Map<String, dynamic> json) {
    type = json['measurement_unit'];
    shoulder = json['shoulder'];
    chest = json['chest'];
    frontShoulderToWaist = json['front_shoulder_to_waist'];
    waist = json['waist'];
    armLength = json['arm_length'];
    hip = json['hip'];
    crotchDepth = json['crotch_depth'];
    waistToKnee = json['waist_to_knee'];
    kneeLine = json['knee_line'];
    neckCircumference = json['neck_circumference'];
    napeToWaist = json['nape_to_waist'];
    backWidth = json['back_width'];
    topArmCircumference = json['top_arm_circumference'];
    waistToFloor = json['waist_to_floor'];
    comment = json['comment'];
    needHelp = json['need_help'];
  }
}
