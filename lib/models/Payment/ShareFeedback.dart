class ShareFeedback {
  List<Questions> questions;

  String bannerImage,note,error;
  static int id = 0;


  ShareFeedback(this.questions);


  ShareFeedback.withError(String error){
    this.error = error;
  }
  ShareFeedback.fromJson(Map<String, dynamic> json) {

    bannerImage = json['banner_image'];
    note = json['note'];

    questions = List<Questions>();
    json['questionnaire'].forEach((v){
      ShareFeedback.id = 0;
      questions.add(Questions.fromJson(v));
    });
  }
}

class Questions {

  String question,type,field;
  String grpValue;
  bool answered;
  List<Answers> answers;
  Questions( {this.question,this.field,this.type, this.answers});


  Questions.fromJson(Map<String, dynamic> json) {

    question = json['question'];
    type = json['type'];
    field = json['field'];
    grpValue = "";
    answers = List<Answers>();
    answered = false;
    json.containsKey('options')?json['options'].forEach((v){

      answers.add(Answers.fromJson(v,ShareFeedback.id++));
    }):"";
  }

  Questions.toJson() {
    Map<String, dynamic> json = Map<String, dynamic>();
    json['question'] = question;
  }
}

class Answers {
  String title;
  String value;
  int id;
  bool selected;
  String selectedValue;
  Answers(this.title, this.value);

  Answers.fromJson(Map<String, dynamic> json,int id) {
    title = json['title'].toString();
    value = json['value'].toString();
    this.id = id;
    print(id);
    selected =false;

  }

  Answers.toJson() {
    Map<String, dynamic> json = Map<String, dynamic>();
    json['id'] = title;
    json['answer'] = value;
  }
}

class ObjectModel{

  String id;
  String value;

  ObjectModel({this.id, this.value});


  @override
  String toString() {
    String finalString  = "$id:$value";
    print(finalString);
    return finalString;
  }

}