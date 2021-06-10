import 'package:azaFashions/repository/LoginRepo.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';


class LocationBloc{

  final _repository = LoginRepo();
  final _locationfetcher = PublishSubject<String>();

  Stream<String> get fetchLocation  => _locationfetcher.stream;

  fetchLoctaionData(BuildContext context) async {
    var itemModel = await _repository.getLocationRepo(context);
    _locationfetcher.sink.add(itemModel.toString());
  }


  dispose() {
    _locationfetcher.close();
  }
}

final location_bloc = LocationBloc();