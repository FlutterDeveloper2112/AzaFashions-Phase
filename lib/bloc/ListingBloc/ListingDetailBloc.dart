import 'package:azaFashions/models/Listing/FilterModel.dart';
import 'package:azaFashions/models/CategoryModel.dart';
import 'package:azaFashions/models/Listing/ChildListingModel.dart';
import 'package:azaFashions/models/Listing/ListingModel.dart';
import 'package:azaFashions/repository/ListingRepo.dart';
import 'package:rxdart/rxdart.dart';


class ListingDetailBloc{

  final _repository = ListingRepo();
  var _newListfetcher = PublishSubject<ListingModel>();
  final _newChildListfetcher = PublishSubject<ChildListingModel>();
  var _categoryFetcher = PublishSubject<CategoryModel>();

  Stream<ListingModel> get fetchList  => _newListfetcher.stream;
  Stream<ChildListingModel> get fetchChildList  => _newChildListfetcher.stream;
  Stream<CategoryModel> get categories  => _categoryFetcher.stream;

  //Fetching MainProduct List
  fetchAllNewData(String url,String sortOption, List<FilterModel> filterList, int pageLink) async {
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
    ListingModel itemModel = await _repository.getListingDetailRepo(url,sortOption,filterApplied,pageLink);
    _newListfetcher.sink.add(itemModel);
  }

  //Fetching Sub Product Items
  fetchAllChildNewData(String url,String sortOption, List<FilterModel> filterList, int pageLink) async {
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
    ChildListingModel itemModel = await _repository.getChildListingDetailRepo(url,sortOption,filterApplied,pageLink);
    _newChildListfetcher.sink.add(itemModel);
  }

  //Main Categories
  getCategories() async {
    CategoryModel response = await _repository.categoriesRepo();
    _categoryFetcher.sink.add(response);
  }

  dispose() {
    _newListfetcher.close();
    _newListfetcher = PublishSubject<ListingModel>();

  }
  categoriesDispose(){
    _categoryFetcher.close();
    _categoryFetcher = PublishSubject<CategoryModel>();
  }
}

final listingdetail_bloc = ListingDetailBloc();