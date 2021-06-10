

import 'package:azaFashions/repository/LoginRepo.dart';
import 'package:azaFashions/utils/ResponseMessage.dart';
import 'package:azaFashions/validator/validators.dart';
import 'package:rxdart/rxdart.dart';

class ForgetPassBloc extends Object with Validators{
  final repository= LoginRepo();
  final forgetPassFetcher = PublishSubject<ResponseMessage>();
  final _emailController =  BehaviorSubject<String>();

  Function(String) get emailChanged => _emailController.sink.add;
  Stream<String> get email => _emailController.stream.transform(emailValidator);
  Stream<bool> get loginCheck => Rx.combineLatest2(email, email, (e, p)=>true);
  Stream<ResponseMessage> get fpFetcher => forgetPassFetcher.stream;


  forgetPassBloc() async{
    var emailData = await repository.getForgetPassRepo(_emailController.value);
    forgetPassFetcher.sink.add(emailData);
  }




  void dispose(){
    forgetPassFetcher.close();
    _emailController.close();
  }

}

