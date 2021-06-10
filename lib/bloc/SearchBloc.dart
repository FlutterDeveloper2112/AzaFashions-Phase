import 'package:azaFashions/models/Listing/ChildListingModel.dart';
import 'package:azaFashions/models/Listing/FilterModel.dart';
import 'package:azaFashions/models/Listing/ListingModel.dart';
import 'package:azaFashions/models/Search/SearchModel.dart';
import 'package:azaFashions/repository/ListingRepo.dart';
import 'package:rxdart/rxdart.dart';
class SearchBloc {

  final _repository = ListingRepo();
  final _searchList = PublishSubject<ChildListingModel>();
  var _autoCompleteSearch = BehaviorSubject<SearchModel>();
  Stream<ChildListingModel> get searchDetails => _searchList.stream;
  Stream<SearchModel> get autoCompleteSearch => _autoCompleteSearch.stream;


  getSearchDetails(String url,String sortOption, List<FilterModel> filterList, int pageLink) async {
      String filterApplied="";

      if(filterList!=null){
        for(int i=0;i<filterList.length;i++){
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
            finalString!=""? filterApplied+="&" : filterApplied+="";
            filterApplied+=finalString!=""?filterList[i].parent_id+"="+finalString:"";
          }

        }
      }
      ChildListingModel itemModel = await _repository.searchRepo(url,sortOption,filterApplied,pageLink);
      _searchList.sink.add(itemModel);
    }




  searchAutoComplete(String query,String sortOption) async {
  /*  _autoCompleteSearch?.close();
    _autoCompleteSearch = BehaviorSubject<SearchModel>();
  */  SearchModel search = await _repository.autoCompleteSearch(query, sortOption);
    _autoCompleteSearch.sink.add(search);
  }
  void dispose() {
    _searchList?.close();
    _autoCompleteSearch?.close();
  }
}
final searchBloc = SearchBloc();