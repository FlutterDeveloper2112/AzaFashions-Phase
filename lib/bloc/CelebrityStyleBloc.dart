import 'package:azaFashions/models/CelebrityList.dart';
import 'package:azaFashions/models/Listing/FilterModel.dart';
import 'package:azaFashions/repository/CelebrityStyleRepo.dart';
import 'package:rxdart/subjects.dart';

class CelebrityStyleBloc{

  final CelebrityStyleRepo celebrityStyleRepo = CelebrityStyleRepo();


  var _celebrityFetcher = BehaviorSubject<CelebrityList>();


  Stream<CelebrityList> get fetchCelebrity  => _celebrityFetcher.stream;

  celebrityStyle(String url,String sortOption, List<FilterModel> filterList, int pageLink) async {
    String filterApplied="";
    if(filterList!=null){
      for(int i =0;i<filterList.length;i++){
        List match = filterList[i].selectedValue.split(',');
        if(i==0){
          print("SPLITTED STRING : ${match.length}");
          String finalString="";
          for(int i=0;i<match.length;i++){
            if(match[i]!="null"){
              finalString+=match[i]+",";
            }
          }
          finalString=finalString!=""?finalString. substring(0,finalString.length - 1):"";
          filterApplied+=finalString!=""?filterList[i].parent_id+"="+finalString:"";

        }

        if(i>0){
          String finalString="";
          for(int j=0;j<match.length;j++){
            if(match[j]!="null"){
              finalString+=match[j]+",";
            }
          }
          finalString=finalString!=""?finalString. substring(0,finalString.length - 1):"";
          filterApplied+=finalString!=""?"&"+filterList[i].parent_id+"="+finalString:"";
        }
      }
    }
    print("FILTER API STRING : ${filterApplied}");
    CelebrityList celebrityList  = await celebrityStyleRepo.celebrityStyleRepo(url,sortOption,filterApplied,pageLink);
    _celebrityFetcher.sink.add(celebrityList);
  }



  void dispose(){
    _celebrityFetcher?.close();
    _celebrityFetcher = BehaviorSubject<CelebrityList>();


  }

}