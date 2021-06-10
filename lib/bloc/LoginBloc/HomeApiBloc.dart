import 'package:azaFashions/models/Login/BulletMenuList.dart';
import 'package:azaFashions/repository/LoginRepo.dart';
import 'package:rxdart/rxdart.dart';


class HomeApiBloc{

  final _repository = LoginRepo();
  final _homefetcher = PublishSubject<BulletMenuList>();

  Stream<BulletMenuList> get fetchHomeData  => _homefetcher.stream;

  fetchAllHomeData() async {
    BulletMenuList itemModel = await _repository.getHomeApiRepo();
    _homefetcher.sink.add(itemModel);
  }

 List<TopMenu> getTopMenuDetails(context){
    List<TopMenu> topMenu= new List<TopMenu>();
    home_bloc.fetchAllHomeData();
    fetchHomeData.first.then((value) {
      value.top_menu.forEach((element) {
        topMenu.add(element);
      });
    });
  return topMenu;

  }

  void dispose() {
    _homefetcher.close();
  }
}

final home_bloc = HomeApiBloc();