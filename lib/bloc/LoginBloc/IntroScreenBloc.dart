import 'package:azaFashions/models/Login/IntroModelList.dart';
import 'package:azaFashions/repository/LoginRepo.dart';
import 'package:rxdart/rxdart.dart';


class IntroScreenBloc{

  final _repository = LoginRepo();
  final _introfetcher = PublishSubject<IntroModelList>();

  Stream<IntroModelList> get fetchAllData  => _introfetcher.stream;

  fetchAllIntroData() async {
     IntroModelList itemModel = await _repository.getIntroScreenRepo();
    _introfetcher.sink.add(itemModel);

  }

  dispose() {
    _introfetcher.close();
  }
}

final bloc = IntroScreenBloc();