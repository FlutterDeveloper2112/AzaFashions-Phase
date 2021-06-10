import 'package:azaFashions/models/CelebrityList.dart';
import 'package:azaFashions/networkprovider/CelebrityProvider.dart';
import 'package:flutter/material.dart';

class CelebrityStyleRepo{


  BuildContext context;

  CelebrityProvider _celebrityProvider = CelebrityProvider();

  Future<CelebrityList> celebrityStyleRepo(String url,String sortOption,String filterApplied,int pageLinks) =>  _celebrityProvider.celebrityStyle(context,url,sortOption,filterApplied,pageLinks);


}