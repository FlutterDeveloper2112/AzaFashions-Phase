class CountryStateList {
  List<CountryState> countryState;
  String success, error = "";

  CountryStateList(this.countryState, this.success, this.error);

  CountryStateList.withError(String error) {
    this.error = error;
  }

  CountryStateList.fromJson(dynamic json) {
    if (json['data']['list'] != null) {
      countryState = new List<CountryState>();
      json['data']['list'].forEach((v) {
        countryState.add(new CountryState.fromJson(v));
      });
    }
  }
}

class CountryState {
  int id;
  String name;


  CountryState({this.id, this.name});

  CountryState.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  CountryState.toJson() {
    Map<String, dynamic> jsonData = {};
    jsonData['id'] = id;
    jsonData['name'] = name;
  }


}
