import 'package:azaFashions/models/Profile/Points.dart';
import 'package:azaFashions/repository/ProfileRepo.dart';
import 'package:rxdart/rxdart.dart';

class LoyaltyBloc{

  final _repository = ProfileRepo();
  final _pointsFetcher = BehaviorSubject<PointsList>();


  Stream<PointsList> get pointFetchers => _pointsFetcher.stream;

  fetchPoints() async {
    PointsList points= await _repository.getLoyaltyPointsRepo();
    _pointsFetcher.sink.add(points);
  }

  void dispose(){
    _pointsFetcher?.close();
  }
}

final loyaltyBloc = LoyaltyBloc();