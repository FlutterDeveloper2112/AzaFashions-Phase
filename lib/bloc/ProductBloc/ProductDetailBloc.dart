import 'package:azaFashions/models/ProductDetail/EmiDetails.dart';
import 'package:azaFashions/models/ProductDetail/ProductItemDetail.dart';
import 'package:azaFashions/repository/ProductDetailRepo.dart';
import 'package:azaFashions/utils/ResponseMessage.dart';
import 'package:azaFashions/validator/validators.dart';
import 'package:rxdart/rxdart.dart';

class ProductDetailsBloc extends Object with Validators{

  final _repository = ProductDetailRepo();
  var _productDetailsFetcher = BehaviorSubject<ProductItemDetail>();

  var _emiFetcher = BehaviorSubject<EmiDetails>();

  var _codAvailFetcher = BehaviorSubject<ResponseMessage>();
  Stream<ProductItemDetail> get productDetails => _productDetailsFetcher.stream;


  Stream<ResponseMessage> get codAvail => _codAvailFetcher.stream;

  Stream<EmiDetails> get emi => _emiFetcher.stream;
  getProductDetails(int productId,String url) async {
    ProductItemDetail details = await _repository.getProductDetailsRepo(productId,url);
    _productDetailsFetcher.sink.add(details);
  }


  codAvailability(String pinCode) async {
    clearCOD();
    ResponseMessage productDetails = await _repository.codAvailabilityRepo(pinCode);
    _codAvailFetcher.sink.add(productDetails);
  }

  emiDetails(String amount) async {
    EmiDetails emiDetails = await _repository.emiDetails(amount);
    _emiFetcher.sink.add(emiDetails);


  }
  void clearCOD(){
    _codAvailFetcher?.close();
    _codAvailFetcher= BehaviorSubject<ResponseMessage>();
  }
  void clearData(){
    _productDetailsFetcher?.close();
    _codAvailFetcher?.close();
    _emiFetcher?.close();
    _codAvailFetcher= BehaviorSubject<ResponseMessage>();
    _productDetailsFetcher= BehaviorSubject<ProductItemDetail>();

  }
}

