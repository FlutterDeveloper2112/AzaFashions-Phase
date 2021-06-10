import 'package:azaFashions/models/Cart/CartListing.dart';
import 'package:azaFashions/models/Checkout/CheckOutListing.dart';
import 'package:azaFashions/repository/CheckoutRepo.dart';
import 'package:rxdart/rxdart.dart';

class CheckoutBloc {
  final _repository = CheckoutRepo();
  final _checkoutItemListfetcher = BehaviorSubject<CheckoutListing>();
  final _coupon = BehaviorSubject<CartListing>();
  final _selectedAddress = BehaviorSubject<CheckoutListing>();


  Stream<CartListing> get couponCode => _coupon.stream;
  Stream<CheckoutListing> get selectAddress => _selectedAddress.stream;


  Stream<CheckoutListing> get fetchCheckoutItemList  => _checkoutItemListfetcher.stream;

//Checkout Items
  fetchAllCheckoutItems(bool is_gift,String gift_instr,bool is_orderInst, String orderIns) async {
    CheckoutListing itemModel = await _repository.getCheckoutItemListRepo(is_gift,gift_instr,is_orderInst,orderIns);
    _checkoutItemListfetcher.sink.add(itemModel);
  }


//Checkout Selected Address
  fetchSelectAddress(int addressId, String selection_type) async {
    CheckoutListing responseMessage = await _repository.getSelectedAddressRepo(addressId,selection_type);
    _selectedAddress.sink.add(responseMessage);
  }

  dispose() {
    _coupon?.close();
  }
}
final checkoutBloc = new CheckoutBloc();
