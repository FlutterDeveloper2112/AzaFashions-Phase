import 'package:azaFashions/models/Listing/Filters.dart';

class DesignerModel {
  Map<String, dynamic> designers;

  static Map<String,dynamic> myDesigners;
  static Map<String,dynamic> featuredDesigners;
  static List<Filters> myDesignersFilters;
  static List<Filters> featuredDesignersFilters;
  List<Filters> filters;
  String success, error = "";
  List<String> alphabets = [
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K",
    "L",
    "M",
    "N",
    "O",
    "P",
    "Q",
    "R",
    "S",
    "T",
    "U",
    "V",
    "W",
    "X",
    "Y",
    "Z",
    "0-9"
  ];

  DesignerModel({this.designers, this.filters});

  DesignerModel.withError(String error,String id) {
    if(error == "No Designers Found" && id==null){
      myDesigners = Map<String,dynamic>();
      featuredDesigners = Map<String,dynamic>();
    }

    this.error = error;
  }

  DesignerModel.fromJson(Map<String, dynamic> json,String type) {
    error = "";
    print("JSON STRING $json");
    if(type == "following-designers"){
      myDesigners = Map<String,dynamic>();
      myDesignersFilters = <Filters>[];
      if (json['data'].toString().contains("filters")) {
        json['data']['filters'].forEach((v) {
          myDesignersFilters.add(Filters.fromJson(v));
        });
      }

      if (json['data']['list'].isNotEmpty) {
        myDesigners = (json['data']['list']);
      } else {
        myDesigners = {};
        alphabets = [];
      }
    }




    else if(type == "featured-designers"){
      featuredDesigners = Map<String,dynamic>();
      featuredDesignersFilters = <Filters>[];
      if (json['data'].toString().contains("filters")) {
        json['data']['filters'].forEach((v) {
          featuredDesignersFilters.add(Filters.fromJson(v));
        });
      }

      if (json['data']['list'].isNotEmpty) {
        featuredDesigners = (json['data']['list']);
      } else {
        featuredDesigners = {};
        alphabets = [];
      }
    }

    else{


      designers = Map<String, dynamic>();

      filters = List<Filters>();

      if (json['data'].toString().contains("filters")) {
        json['data']['filters'].forEach((v) {
          filters.add(Filters.fromJson(v));
        });
      }
      if (json['data']['list'].isNotEmpty) {
        designers = (json['data']['list']);
      } else {
        designers = {};
        alphabets = [];
      }
    }

  }
}
