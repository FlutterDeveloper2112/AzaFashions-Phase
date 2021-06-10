import 'package:azaFashions/models/Listing/ChildListingModel.dart';
import 'package:azaFashions/repository/ListingRepo.dart';
import 'package:rxdart/rxdart.dart';

class SimilarProductBloc{


  final _repo = ListingRepo();
  final _similarProductFetcher = PublishSubject<ChildListingModel>();
  final _recentlyViewedFetcher = PublishSubject<ChildListingModel>();

  Stream<ChildListingModel> get similarProduct => _similarProductFetcher.stream;
  Stream<ChildListingModel> get recentlyViewed => _recentlyViewedFetcher.stream;

  fetchSimilarProducts(int productId) async {
    ChildListingModel items = await _repo.similarProductRepo(productId);
    _similarProductFetcher.sink.add(items);
  }

  fetchRecentProducts() async {
    ChildListingModel items = await _repo.recentlyViewedRepo();
    _recentlyViewedFetcher.sink.add(items);
  }
  void dispose(){

    _similarProductFetcher?.close();
    _recentlyViewedFetcher?.close();
  }
}

final similarBloc = SimilarProductBloc();