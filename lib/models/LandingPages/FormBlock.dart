

class FormBlock{
  String image,action_url,heading,sub_heading;

  FormBlock({this.image, this.action_url, this.heading,
    this.sub_heading});

  factory FormBlock.fromJson(Map<String, dynamic> json) {
    return FormBlock(
      image: json["image"],
      action_url: json["action_url"],
      heading: json["heading"],
      sub_heading: json["sub_heading"],
    );
  }



}