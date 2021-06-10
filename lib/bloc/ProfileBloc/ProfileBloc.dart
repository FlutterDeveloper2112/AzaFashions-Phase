import 'package:azaFashions/models/Login/UserLogin.dart';
import 'package:azaFashions/repository/ProfileRepo.dart';
import 'package:rxdart/rxdart.dart';

class ProfileBloc{


  final _repository = ProfileRepo();

  final _accountDetailsFetcher = PublishSubject<UserLogin>();

  Stream<UserLogin> get accountDetails => _accountDetailsFetcher.stream;


  getAccountDetails() async {
    UserLogin details = await _repository.getAccountDetails();
    _accountDetailsFetcher.sink.add(details);
  }


  void dispose(){
    _accountDetailsFetcher?.close();
  }
}

final profilebloc = ProfileBloc();