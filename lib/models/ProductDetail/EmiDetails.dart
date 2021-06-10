class EmiDetails{


  List<EmiAvailable> emi;

  EmiDetails(this.emi);

  EmiDetails.fromJson(Map<String,dynamic> json){

    emi = List<EmiAvailable>();
    json['list'].forEach((v){
      print("EMI JSON: ${v.toString()}");
      emi.add(EmiAvailable.fromJson(v));
    });
  }
}

class EmiAvailable{

  int bankId;
  String bankName;
  String bankImage;
  String minimumAmount;

  List<EmiOptions> emiOptions;

  EmiAvailable.fromJson(Map<String,dynamic> json){
    print("EMI JSON: ${json.toString()}");
    bankId = json['bank_id'];
    bankName = json['bank_name'];
    bankImage  = json['bank_image']!=null || json['bank_image']!=""?json['bank_image']:"";
    minimumAmount = json['minimum_amount'];

    emiOptions = List<EmiOptions>();
    json['emi_options'].forEach((v){
      emiOptions.add(EmiOptions.fromJson(v));
    });
  }
}


class EmiOptions{

  int tenure;
  String interestRate;
  String discount;
  String emi;
  String interestPayable;
  String amountPayable;

  EmiOptions({this.tenure, this.interestRate, this.discount, this.emi,
    this.interestPayable, this.amountPayable});


  EmiOptions.fromJson(Map<String,dynamic> json){
    print("EMI JSON: ${json.toString()}");
    tenure = json['tenure'];
    interestRate = json['interest_rate'];
    discount = json['discount'];
    emi = json['emi'];
    interestPayable  = json['interest_payable'];
    amountPayable = json['amount_payable'];

  }
}