import 'package:azaFashions/models/Cart/CartListing.dart';
import 'package:azaFashions/models/Cart/CartModel.dart';
import 'package:azaFashions/models/LandingPages/ChildLandingPage.dart';
import 'package:azaFashions/models/LandingPages/BaseLandingPage.dart';
import 'package:azaFashions/repository/LandingRepo.dart';
import 'package:azaFashions/utils/ResponseMessage.dart';
import 'package:azaFashions/validator/validators.dart';
import 'package:rxdart/rxdart.dart';

class LandingPageData  extends Object with Validators {
  final _repository = LandingRepo();
  final _landingPagefetcher = PublishSubject<LandingPage>();
  final _childlandingPagefetcher = PublishSubject<ChildLandingPage>();
  final _offerslandingPagefetcher = PublishSubject<LandingPage>();
  final _homelandingPagefetcher = PublishSubject<LandingPage>();
  final _subscriptionfetcher = PublishSubject<LandingPage>();
  final _unsubscriptionfetcher = PublishSubject<LandingPage>();

  var _emailController = BehaviorSubject<String>();

  final _weddingFetcher = PublishSubject<ResponseMessage>();

  Function(String) get emailChanged => _emailController.sink.add;

  Stream<LandingPage> get fetchLandingPage  => _landingPagefetcher.stream;
  Stream<ChildLandingPage> get fetchChildLandingPage  => _childlandingPagefetcher.stream;
  Stream<LandingPage> get fetchOffersLandingPage  => _offerslandingPagefetcher.stream;
  Stream<LandingPage> get fetchHomeLandingPage  => _homelandingPagefetcher.stream;
  Stream<LandingPage> get fetchSubscription  => _subscriptionfetcher.stream;
  Stream<LandingPage> get fetchUnSubscription  => _unsubscriptionfetcher.stream;
  Stream<String> get email => _emailController.stream.transform(emailValidator);
  Stream<ResponseMessage> get weddingDetail=> _weddingFetcher.stream;

  //Main Landing Page Items
  fetchLandingItems(String pageName) async {
    LandingPage itemModel = await _repository.getBaseLandingDetails(pageName);
    _landingPagefetcher.sink.add(itemModel);
  }
  //Sub Landing Page Items
  fetchChildLandingItems(String pageName) async {
    ChildLandingPage itemModel = await _repository.getChildLandingDetails(pageName);
    _childlandingPagefetcher.sink.add(itemModel);
  }

  //Home Landing Page Items
  fetchHomeLandingItems(String pageName) async {
    LandingPage itemModel = await _repository.getBaseLandingDetails(pageName);
    _homelandingPagefetcher.sink.add(itemModel);
  }

  //Offers Landing Page Item
  fetchOffersLandingItems(String pageName) async {
    LandingPage itemModel = await _repository.getBaseLandingDetails(pageName);
    _offerslandingPagefetcher.sink.add(itemModel);
  }

  //Email Subscription
  fetchSubscriptionData(String emailData) async {
    LandingPage itemModel = await _repository.getSubscriptionDetails(emailData);
    _subscriptionfetcher.sink.add(itemModel);
    _emailController.value=="";
  }

  //Email UnSubscription
  fetchUnSubscriptionData(String emailData) async {
    LandingPage itemModel = await _repository.getUnSubscriptionDetails(emailData);
    _subscriptionfetcher.sink.add(itemModel);

  }

  //Wedding Form Block
  fetchWeddingData(String email,String mobile,String message,String url) async {
    ResponseMessage responseMessage = await _repository.weddingBlock(email, mobile, message,url);
    _weddingFetcher.sink.add(responseMessage);
  }




  void dispose(){
    _landingPagefetcher?.close();
    _homelandingPagefetcher?.close();

  }
}
final landingPageData = new LandingPageData();

