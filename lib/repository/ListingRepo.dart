import 'dart:async';
import 'package:azaFashions/models/CategoryModel.dart';
import 'package:azaFashions/models/Listing/ChildListingModel.dart';
import 'package:azaFashions/models/Listing/ListingModel.dart';
import 'package:azaFashions/models/Search/SearchModel.dart';
import 'package:azaFashions/networkprovider/ListingProvider.dart';
import 'package:flutter/cupertino.dart';

class ListingRepo{
  BuildContext context;

  ListingProvider _apiProvider = new ListingProvider();
  //Future<ListingModel> getDesignerRepo(String sortOption,String url) =>  _apiProvider.getDesignerList(context,sortOption,url);
  Future<ChildListingModel> searchRepo(String url,String sortOption,String filterApplied,int pageLinks) => _apiProvider.getSearchListDetails(context,url,sortOption,filterApplied,pageLinks);
  Future<SearchModel> autoCompleteSearch(String query,String sortOption) => _apiProvider.searchAutoComplete(context, query,sortOption);

  Future<ChildListingModel> boughtTogetherRepo(int productId)=> _apiProvider.boughtTogether(context, productId);

  Future<ChildListingModel> similarProductRepo(int productId) => _apiProvider.similarProducts(context, productId);

  Future<ListingModel> getListingDetailRepo(String url,String sortOption,String filterApplied,int pageLinks) =>  _apiProvider.getListingDetails(context,url,sortOption,filterApplied,pageLinks);
  Future<ChildListingModel> getChildListingDetailRepo(String url,String sortOption,String filterApplied,int pageLinks) =>  _apiProvider.getChildListingDetails(context,url,sortOption,filterApplied,pageLinks);

  Future<ChildListingModel> recentlyViewedRepo() => _apiProvider.recentlyViewed(context);

  Future<CategoryModel> categoriesRepo()=> _apiProvider.getCategories(context);
}
