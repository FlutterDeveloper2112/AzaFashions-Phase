import 'package:azaFashions/models/Orders/CancelReasonsListing.dart';
import 'package:azaFashions/models/Orders/OrderItemListing.dart';
import 'package:azaFashions/models/Orders/OrderListing.dart';
import 'package:azaFashions/models/Orders/TrackingDetails.dart';
import 'package:azaFashions/repository/ProfileRepo.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';


class OrderBloc{

  final _repository = ProfileRepo();
  final _orderListfetcher = PublishSubject<OrderListing>();
  final _orderItemListfetcher = PublishSubject<OrderItemList>();
  final _productFeedbackListfetcher = PublishSubject<OrderItemList>();

  final _cancelOrderItemListfetcher = PublishSubject<CancelReasonsListing>();
  final _cancelReasonsListfetcher = PublishSubject<CancelReasonsListing>();
  final _trackingDetailsListfetcher = PublishSubject<TrackingDetails>();



  Stream<OrderListing> get fetchOrderList  => _orderListfetcher.stream;
  Stream<OrderItemList> get fetchOrderItemList  => _orderItemListfetcher.stream;
  Stream<OrderItemList> get productFeedbackList  => _productFeedbackListfetcher.stream;

  Stream<CancelReasonsListing> get cancelOrderItemList  => _cancelOrderItemListfetcher.stream;
  Stream<CancelReasonsListing> get cancelReasonsList  => _cancelReasonsListfetcher.stream;
  Stream<TrackingDetails> get trackingDetails  => _trackingDetailsListfetcher.stream;




  fetchAllOrderData() async {
    OrderListing itemModel = await _repository.getOrderListRepo();
    _orderListfetcher.sink.add(itemModel);
  }
  fetchAllOrderItems(int id) async {
    OrderItemList itemModel = await _repository.getOrderItemListRepo(id);
    _orderItemListfetcher.sink.add(itemModel);
  }
  fetchProductShareFeedback(int orderId,int itemId,int rating,String comment) async {
    OrderItemList itemModel = await _repository.shareProductFeedbackRepo(orderId,itemId,rating,comment);
    _productFeedbackListfetcher.sink.add(itemModel);
  }

  cancelOrderItem(CancelReasons cancelReasons,int orderId,int itemId) async {
    CancelReasonsListing itemModel = await _repository.cancelItemRepo(cancelReasons,orderId,itemId);
    _cancelOrderItemListfetcher.sink.add(itemModel);
  }

  cancelReasons() async {
    CancelReasonsListing itemModel=await _repository.cancelResonsRepo();
    _cancelReasonsListfetcher.sink.add(itemModel);
  }

  trackItems(BuildContext context,String orderId,String itemId) async {
    TrackingDetails itemModel=await _repository.trackItemsRepo(context,orderId,itemId);
    _trackingDetailsListfetcher.sink.add(itemModel);

  }


  dispose() {
    _orderListfetcher.close();
    _cancelOrderItemListfetcher.close();
    _orderItemListfetcher.close();

  }
}

final order_bloc = OrderBloc();