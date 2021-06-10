class PriceMatch{


  String title;
  String description;

  PriceMatch(this.title, this.description);

  PriceMatch.fromJson(Map<String,dynamic> json){

    title = json['title'];
    description = json['description'];
  }
}