import 'package:azaFashions/models/Profile/WishList.dart';
import 'package:azaFashions/repository/ProfileRepo.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class WishListBloc{

  final _repository = ProfileRepo();
  final _wishListFetcher = PublishSubject<WishListArray>();
  var _addWishListFetcher = BehaviorSubject<WishListArray>();
  var _removeWishListFetcher = BehaviorSubject<WishListArray>();


  Stream<WishListArray> get wishList => _wishListFetcher.stream;
  Stream<WishListArray> get addWishList => _addWishListFetcher.stream;
  Stream<WishListArray> get removeWishList => _removeWishListFetcher.stream;



  getWishList() async {
    WishListArray items = await _repository.wishlistRepo();
    _wishListFetcher.sink.add(items);
  }

  addWishListData(BuildContext context,int productId) async {
    WishListArray items = await _repository.addWishlistRepo(context, productId);
    _addWishListFetcher.sink.add(items);
  }

  removeWishListData(BuildContext context,int productId,String source) async {
    WishListArray items = await _repository.removeWishlistRepo(context, productId,source);
    _removeWishListFetcher.sink.add(items);
  }

  void clearAddWishlist(){
    _addWishListFetcher = BehaviorSubject<WishListArray>();
    _removeWishListFetcher = BehaviorSubject<WishListArray>();
  }

  void dispose(){
    _wishListFetcher?.close();
    _addWishListFetcher?.close();
    _removeWishListFetcher?.close();
  }
}

final wishList = WishListBloc();