
import 'package:azaFashions/models/Payment/PaymentOptions.dart';
import 'package:azaFashions/models/Payment/PaymentStatus.dart';
import 'package:azaFashions/models/Payment/ShareFeedback.dart';
import 'package:azaFashions/repository/PaymentRepo.dart';
import 'package:azaFashions/utils/ResponseMessage.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class PaymentBloc {
  final _repository = PaymentRepo();
  final _paymentItemListfetcher = BehaviorSubject<PaymentOptions>();
  final _paymentStatusetcher = PublishSubject<PaymentStatus>();

  final _sendFeedbackFetcher = BehaviorSubject<ResponseMessage>();
  final _recordOrderPlacedFeedbackFetcher = BehaviorSubject<ResponseMessage>();


  var _feedbackFetcher = BehaviorSubject<ShareFeedback>();


  Stream<PaymentOptions> get fetchPaymentItemList  => _paymentItemListfetcher.stream;
  Stream<PaymentStatus> get fetchPaymentStatus  => _paymentStatusetcher.stream;

  Stream<ShareFeedback> get fetchFeedback => _feedbackFetcher.stream;

  Stream<ResponseMessage> get sendFeedback => _sendFeedbackFetcher.stream;
  Stream<ResponseMessage> get recordOrderPlacedFeedback => _recordOrderPlacedFeedbackFetcher.stream;

  fetchAllPaymentItems() async {
    PaymentOptions itemModel = await _repository.getpPaymentItemListRepo();
    _paymentItemListfetcher.sink.add(itemModel);
  }

  fetchPaymentStatusBloc(String url,String transId) async {
    PaymentStatus itemModel = await _repository.getPaymentStatusRepo(url,transId);
    _paymentStatusetcher.sink.add(itemModel);
  }
  fetchDirectPaymentStatusBloc(BuildContext context) async {
    PaymentStatus itemModel = await _repository.getDirectPaymentStatusRepo(context);
    _paymentStatusetcher.sink.add(itemModel);
  }


  getFeedback() async {
    ShareFeedback feedback = await _repository.feedback();
    _feedbackFetcher.sink.add(feedback);
  }

  recordFeedback(Map<String,String> body) async {
    ResponseMessage message = await _repository.sendFeedback(body);
    _sendFeedbackFetcher.sink.add(message);
  }

  orderPlacedFeedback(int body) async {
    ResponseMessage message = await _repository.recordOrderPlacedFeedback(body);
    _recordOrderPlacedFeedbackFetcher.sink.add(message);
  }


  clearFeedback(){
    _feedbackFetcher?.close();
    _feedbackFetcher = BehaviorSubject<ShareFeedback>();
  }
  void dispose(){
    _paymentItemListfetcher?.close();
    _feedbackFetcher?.close();
    _sendFeedbackFetcher?.close();
    _recordOrderPlacedFeedbackFetcher?.close();

  }
}
final paymentBloc = new PaymentBloc();

