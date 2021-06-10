import 'package:azaFashions/models/Cart/CartListing.dart';
import 'package:azaFashions/models/Cart/CartModel.dart';
import 'package:azaFashions/repository/CartRepo.dart';
import 'package:azaFashions/repository/CheckoutRepo.dart';
import 'package:rxdart/rxdart.dart';

class CartBloc {
  final _repository = CartRepo();
  final _cartItemListfetcher = BehaviorSubject<CartListing>();
  final _removeCartListFetcher = PublishSubject<CartListing>();
  final _addCartListFetcher = BehaviorSubject<CartListing>();

  var _errorFetcher = BehaviorSubject<CartListing>();

  Stream<CartListing> get fetchCartItemList  => _cartItemListfetcher.stream;
  Stream<CartListing> get removeCartList => _removeCartListFetcher.stream;
  Stream<CartListing> get addCartList => _addCartListFetcher.stream;
  Stream<CartListing> get errorData => _errorFetcher.stream;



//Add Items to Cart
  addCartItems(CartModel cartModel) async {
    CartListing model= await _repository.addCartRepo(cartModel);
    _addCartListFetcher.sink.add(model);
  }

//Cart Items
  fetchAllCartItems() async {
    CartListing itemModel = await _repository.getCartItemListRepo();
    _cartItemListfetcher.sink.add(itemModel);
  }

  //Removing Item from Cart
  removeItem(int productId, int sizeId, int quantity,String source) async {
    CartListing model=await _repository.removeCartItemRepo(productId, sizeId, quantity,source);
    _removeCartListFetcher.add(model);
  }

  //Redeem Points
  redeemPoints(String action, String type, int amount) async {
    CartListing message = await CheckoutRepo().redeem(action, type, amount);
    print(message.error);
    if(message.error!=null){
      _errorFetcher.sink.add(message);
    }
    else{
      _cartItemListfetcher.sink.add(message);
    }
  }

 //Redeem Coupon
  coupon(String coupon,String action) async {
    CartListing message = await CheckoutRepo().couponRepo(coupon,action);
    print(message.error);
    if(message.error!=null){
      _errorFetcher.sink.add(message);
      return message.error;
    }
    else{
      _cartItemListfetcher.sink.add(message);
      return "true";
    }
  }

  void dispose(){
    _cartItemListfetcher?.close();
    _removeCartListFetcher?.close();
    _addCartListFetcher?.close();

  }
}
final cartBloc = new CartBloc();

