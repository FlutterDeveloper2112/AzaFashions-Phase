import 'package:azaFashions/models/Designer/DesignerModel.dart';
import 'package:azaFashions/networkprovider/DesignerProvider.dart';
import 'package:azaFashions/utils/ResponseMessage.dart';
import 'package:flutter/material.dart';

class DesignerRepo {
  BuildContext context;

  DesignerProvider _apiProvider = DesignerProvider();

  Future<DesignerModel> getDesignerRepo(String pageName,String id) =>
      _apiProvider.getDesigners(context, pageName,id);

  Future<ResponseMessage> followDesignerRepo(int designerId,String action) =>
      _apiProvider.followDesigner(context, designerId,action);
}
