import 'package:azaFashions/models/Designer/DesignerModel.dart';
import 'package:azaFashions/repository/DesignerRepo.dart';
import 'package:azaFashions/ui/DESIGNER/MyDesigner.dart';
import 'package:azaFashions/utils/ResponseMessage.dart';
import 'package:rxdart/rxdart.dart';

class DesignerBloc {
  final _repository = DesignerRepo();

  var _allDesignerFetcher = BehaviorSubject<DesignerModel>();
  var _featuredDesignerFetcher = BehaviorSubject<DesignerModel>();
  var _myDesignerFetcher = BehaviorSubject<DesignerModel>();
  var _followDesignerFetcher = BehaviorSubject<ResponseMessage>();
  var _unFollowDesignerFetcher = BehaviorSubject<ResponseMessage>();

  Stream<DesignerModel> get allDesigners => _allDesignerFetcher.stream;
  Stream<DesignerModel> get featuredDesigners => _featuredDesignerFetcher.stream;
  Stream<DesignerModel> get myDesigners => _myDesignerFetcher.stream;
  Stream<ResponseMessage> get follow => _followDesignerFetcher.stream;
  Stream<ResponseMessage> get unFollow => _unFollowDesignerFetcher.stream;

  getAllDesigners({String id}) async {
    clearAllDesigner();
    DesignerModel designerModel =
    await _repository.getDesignerRepo("designers",id);
    _allDesignerFetcher.sink.add(designerModel);
  }


  getFeaturedDesigners({String id}) async {
    clearFeaturedDesigner();
    DesignerModel designerModel =
    await _repository.getDesignerRepo("featured-designers",id);
    _featuredDesignerFetcher.sink.add(designerModel);
  }

  getMyDesigners({String id}) async {
    clearMyDesigner();
    DesignerModel designerModel = await _repository.getDesignerRepo("following-designers",id);
    _myDesignerFetcher.sink.add(designerModel);
    print(designerModel.error);


  }
  followDesigner(int designerId,String action) async {
    ResponseMessage message=await _repository.followDesignerRepo(designerId,action);
    if(action=="follow"){
      _followDesignerFetcher.sink.add(message);
    }
    else{
      _unFollowDesignerFetcher.sink.add(message);
    }
  }



  void disposeFollow() async {

    _followDesignerFetcher?.close();
    _unFollowDesignerFetcher?.close();


    _followDesignerFetcher = BehaviorSubject<ResponseMessage>();

    _unFollowDesignerFetcher = BehaviorSubject<ResponseMessage>();
  }

  void clearMyDesigner(){

    _myDesignerFetcher?.close();
    _myDesignerFetcher = BehaviorSubject<DesignerModel>();
    print("CLEAR CALLED");
  }

  void clearAllDesigner(){
    _allDesignerFetcher?.close();
    _allDesignerFetcher = BehaviorSubject<DesignerModel>();
  }

  void clearFeaturedDesigner(){
    _featuredDesignerFetcher?.close();
    _featuredDesignerFetcher = BehaviorSubject<DesignerModel>();
  }

}

final designerBloc = DesignerBloc();
