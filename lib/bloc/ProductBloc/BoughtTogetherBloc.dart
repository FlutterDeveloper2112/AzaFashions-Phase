import 'package:azaFashions/models/Listing/ChildListingModel.dart';
import 'package:azaFashions/repository/ListingRepo.dart';
import 'package:rxdart/rxdart.dart';

class BoughtTogetherBloc{

  final _repository = ListingRepo();

  final _boughtTogetherFetcher = PublishSubject<ChildListingModel>();


  Stream<ChildListingModel> get boughtTogether=> _boughtTogetherFetcher.stream;
  fetchBoughtTogether(int productId) async {
    ChildListingModel items = await _repository.boughtTogetherRepo(productId);
    _boughtTogetherFetcher.sink.add(items);
  }


  void dispose(){
    _boughtTogetherFetcher?.close();
  }
}

final boughtTogetherBloc = BoughtTogetherBloc();