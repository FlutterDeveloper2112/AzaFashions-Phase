import 'package:azaFashions/models/Login/SocialLoginModel.dart';
import 'package:azaFashions/models/Login/UserLogin.dart';
import 'package:azaFashions/repository/LoginRepo.dart';
import 'package:rxdart/rxdart.dart';


class SocialLoginBloc{

  final _repository = LoginRepo();
  final _fbfetcher = PublishSubject<SocialLoginModel>();
  final _googlefetcher = PublishSubject<SocialLoginModel>();
  final _socialfetcher = PublishSubject<UserLogin>();
  var _appleFetcher = PublishSubject<SocialLoginModel>();


  Stream<SocialLoginModel> get fetchfbData  => _fbfetcher.stream;
  Stream<SocialLoginModel> get fetchgoogleData  => _googlefetcher.stream;
  Stream<UserLogin> get fetchSocialData  => _socialfetcher.stream;
  Stream<SocialLoginModel> get fetchAppleData => _appleFetcher.stream;

  Future<SocialLoginModel> fetchAppleLoginData() async {
    SocialLoginModel itemModel = await _repository.getAppleModelRepo();
    _appleFetcher.sink.add(itemModel);

  }

  fetchFacebookLoginData() async {
    SocialLoginModel itemModel = await _repository.getFacebookLoginModelRepo();
    _fbfetcher.sink.add(itemModel);
  }

  fetchGoogleLoginData() async {
    SocialLoginModel itemModel = await _repository.getGoogleLoginModelRepo();
    _googlefetcher.sink.add(itemModel);
  }

  fetchSocialLoginData(SocialLoginModel model) async {
    UserLogin itemModel = await _repository.getSocialLogin(model);
    _socialfetcher.sink.add(itemModel);
  }

  disposeApple(){

    _appleFetcher?.close();
    _appleFetcher = PublishSubject<SocialLoginModel>();

  }

  void dispose() {
    _googlefetcher.close();
    _fbfetcher.close();
    _socialfetcher.close();
  }
}

final sociallogin_bloc = SocialLoginBloc();